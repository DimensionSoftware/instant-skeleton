
export list = [
  [ \HomePage,    '/' ] # HomePage route name loads shared/react/HomePage.ls

  # more route examples:
  #[ \PromoPage,            '/clients/:Client_id/promos' ]
  #[ \PromoPage,            '/clients/:Client_id/promos/page/:n' ]
  #[ \PromoEditorPage,      '/clients/:Client_id/promos/:Promo_id' ]
]


# Given a route name and parameters, return a URL path.  (Based on Camping's R function)
#
# @param  {String} name       route name
# @param  {String} ...args    varargs for each path variable of route
# @return {String}            path
export r = (name, ...args) ->
  route = for r in list when r.0 is name then r
  if not route
    throw new Error("Route '#name' not found.")
  args.reduce ((m, i) -> m.replace /:(\w+)/, i), route.0.1, args

# vim:fdm=indent
