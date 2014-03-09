class QuestionComponent < Cms::Component

  cms_page true
  cms_attribute :question, label: "The Question"
  cms_attribute :foo_page_id, as: :select

  cms_link_attribute :store_link

  image_accessor :image
  cms_dragonfly_image_attribute :image

  cms_subcomponent :definition
  cms_default_subcomponent :definition, count: 2

  cms_searchable_attributes :question

end
