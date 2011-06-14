# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

categories = [
  { :name => "verduras y hortalizas", :slug => "verduras-y-hortalizas" },
  { :name => "carne",                 :slug => "carne" }, 
  { :name => "pescados y mariscos",   :slug => "pescados-y-mariscos" }, 
  { :name => "aves y caza",           :slug => "aves-y-caza" }, 
  { :name => "legumbres",             :slug => "legumbres" }, 
  { :name => "pasta",                 :slug => "pasta" }, 
  { :name => "arroz",                 :slug => "arroz" }, 
  { :name => "postres",               :slug => "postres" }, 
  { :name => "sopas y caldos",        :slug => "sopas-y-caldos" }, 
  { :name => "ensaladas",             :slug => "ensaladas" }, 
  { :name => "patatas",               :slug => "patatas" }, 
  { :name => "huevos y lacteos",      :slug => "huevos-y-lacteos" }, 
  { :name => "soja y derivados",      :slug => "soja-y-derivados" }, 
  { :name => "frutas",                :slug => "frutas" },
  { :name => "embutidos",             :slug => "embutidos" }, 
  { :name => "bebidas",               :slug => "bebidas" }
]

Category.create(categories)
