class DefinitionComponent < Cms::Component

  cms_name "Definitive Definition"

  cms_attribute :term, default: "My Default Term"
  cms_attribute :definition, class: 'wysiwyg span8', as: :textarea, rows: 5
  
end
