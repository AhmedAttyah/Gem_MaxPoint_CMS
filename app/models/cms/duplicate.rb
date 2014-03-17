module Cms
  class Duplicate
    include ActiveModel::Validations
    include ActiveModel::Conversion
    extend ActiveModel::Naming

    validates_presence_of :to_locality

    @@fromLocalityID      # from locality ID
    @@toLocalityID        # to locality ID
    @@copied = []         # array of the ids for the pages copied

    # select query to get records
    def self.query(type,requirement,field=nil)
      case type
        when type = 'page'
          return Page.where(field => requirement)
        when type = 'link'
          return Link.where(field => requirement)
        when type = 'component'
          return Component.where(field => requirement)
        when type = 'Page'
          return Page.find_by_id(requirement)
        when type = 'Link'
          return Link.find_by_id(requirement)
        when type = 'Component'
          return Component.find_by_id(requirement)
      end
    end

    # creates log record of copy
    def self.copyLog(page,clone_page,category)
      copy = Copy.new
      copy.category = category
      copy.locality_from = @@fromLocalityID
      copy.locality_to = @@toLocalityID
      copy.id_from = page.id
      copy.id_to = clone_page.id
      copy.save

      @@copied << clone_page.id # add to array
    end

    # insert new parent_id into pages
    def self.parentID(category)
      object = self.query(category,@@copied,'id')

      object.each do |t|
        if t.parent_id  # only go back over records that have a parent id
          getID = Copy.select("id_to").where(:id_from => t.parent_id, :category => category).first
          parent = self.query(category.capitalize,t.id)
          if getID  # have to run this because one of the components has a parent_id to a component that doesn't exist
            parent.parent_id = getID.id_to
          end
          parent.save
        end
      end
    end

    # clones record
    def self.cloneRecord(page,type)
      clone_page = page.dup
      clone_page.locality_id = @@toLocalityID               # makes copied page have new locality
      clone_page.copy += [@@fromLocalityID,@@toLocalityID]  # have to make this record so newly copied pages can't be copied back to their original locality
      clone_page.copy_from = @@fromLocalityID               # makes record of where page was copied from

      if type == 'link' || type == 'component'  # this can run here because link && component copies are called after page copies
        clonePageID = Copy.select("id_to").where(:id_from => page.page_id, :category => 'page', :locality_from => @@fromLocalityID, :locality_to => @@toLocalityID).first
        if clonePageID
          clone_page.page_id = clonePageID.id_to
        end
      end

      clone_page.save
      self.copyLog(page,clone_page,type)
    end

    # copy pages
    def self.copyPages(type)
      from = self.query(type,@@fromLocalityID,'locality_id')
        
      from.each do |to|
        if to.copy.exclude? @@toLocalityID  # makes sure record can't be copied to same locality twice and can't be copied back to original locality
          self.cloneRecord(to,type)
          to.copy += [@@toLocalityID]  # makes record that page has been copied
          if to.copy.exclude? @@fromLocalityID  # so when record gets copied, it puts the from locality in so you cant copy back to it
            to.copy += [@@fromLocalityID]
          end
          to.save
        end
      end

      self.parentID(type)
    end

    # main function
    def self.main(to_locality,from_locality)
      @@fromLocalityID = from_locality.to_i      # assigns from locality ID
      @@toLocalityID = to_locality.to_i          # assigns to locality ID

      self.copyPages('page')
      self.copyPages('link')
      self.copyPages('component')
    end

    def persisted?
      false
    end
  end
end
