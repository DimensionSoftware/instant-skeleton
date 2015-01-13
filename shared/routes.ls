export list = [
  # <ROUTES>
  [ \HomePage,    '/' ],
  [ \Welcome,    '/welcome' ]

  # route examples:
  #[ \PromoPage,            '/clients/:Client_id/promos' ]
  #[ \PromoPage,            '/clients/:Client_id/promos/page/:n' ]
  #[ \PromoEditorPage,      '/clients/:Client_id/promos/:Promo_id' ]
  # </ROUTES>
]


# Given a route name and parameters, return a URL path.  (Based on Camping's R function)
#
# @param  {String} name       route name
# @param  {String} ...args    varargs for each path variable of route
# @return {String}            path
export r = (name, ...args) ->
  route = list |> find -> it.0 is name
  if not route
    throw new Error("Route '#name' not found.")
  fold ((m, i) -> m.replace /:(\w+)/, i), route.1, args

# Given a route name, route.list index and parameters, return a URL path.
#
# @param  {String} name       route name
# @param  {String} n          index in route matches
# @param  {String} ...args    varargs for each path variable of route
# @return {String}            path
export rn = (name, n, ...args) ->
  route = (list |> filter -> it.0 is name)[n]
  if not route
    throw new Error("Route '#name' not found.")
  fold ((m, i) -> m.replace /:(\w+)/, i), route.1, args

# vim:fdm=indent
