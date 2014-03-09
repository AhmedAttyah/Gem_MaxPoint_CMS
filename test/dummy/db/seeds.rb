user = Cms::User.create!(name: "Mister Admin", email: "user@vasari.com", password: 'password')

en = Cms::Locality.create! name: "English", slug: 'en'
la = Cms::Locality.create! name: "Latin", slug: 'la'

config = Cms::Configuration.create! name: "Dummy", default_locality_id: en.id

home = Cms::Page.create! title: "Home", locality_id: en.id
one = Cms::Page.create! title: "One", slug: 'one', parent_id: home.id, locality_id: en.id
two = Cms::Page.create! title: "Two", slug: 'two', parent_id: one.id, locality_id: en.id

domi = Cms::Page.create! title: "Domi (Home)", locality_id: la.id
unun = Cms::Page.create! title: "Unum (One)", slug: 'unum', parent_id: domi.id, locality_id: la.id
duo = Cms::Page.create! title: "Duo (Two)", slug: 'duo', parent_id: unun.id, locality_id: la.id
