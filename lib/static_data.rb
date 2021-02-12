class StaticData
	# constants
	FEATURED_IN_NEIGHBORHOODS = [
    'Lower Manhattan',
    'Midtown Manhattan',
    'Upper East Side',
    'Upper West Side',
    'Upper Manhattan',
    'Brooklyn',
    'Queens',
    'Bronx'
  ].freeze

  BEDROOMS = ['Room', 'Studio', '1 Bedroom',  '2 Bedroom',  '3 Bedroom', '4+ Bedroom'].freeze

  BUDGET = [
    '$1,750',
    '$2,000',
    '$2,500',
    '$3,000',
    '$3,500',
    '$4,000',
    '$4,500',
    '$5,000',
    '$6,000',
    '$7,000',
    '$8,000',
    '$9,000',
    '$10,000',
    '$12,500',
    '$15,000'
  ].freeze

  ADMIN_NAV_MENU = [
    { title: 'Buildings',            url: '/buildings'},
    { title: 'Units',                url: '/units'},
    { title: 'Listings',             url: '/listings'},
    { title: 'Users',                url: '/users'},
    { title: 'Documents',            url: '/documents'},
    { title: 'Reviews',              url: '/reviews'},
    { title: 'Guides',               url: '/buildings'},
    { title: 'Management companies', url: '/management_companies'},
    { title: 'Price Range',          url: '/price_ranges'},
    { title: 'Featured Comps',       url: '/featured_comps'},
    { title: 'Featured buildings',   url: '/featured_buildings'},
    { title: 'Featured agents',      url: '/featured_agents'},
    { title: 'Featured Listings',    url: '/featured_listings'}
  ]

  FeaturedObjects = ['FeaturedBuilding', 'FeaturedAgent', 'FeaturedListing']

end