SimpleNavigation::Configuration.run do |navigation|  

  navigation.selected_class = 'active'

  navigation.items do |primary|
    primary.item(:confirmations, 'Activation du compte', '#')
  end
  
end