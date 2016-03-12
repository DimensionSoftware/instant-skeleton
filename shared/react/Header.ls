
require! {
  uuid
  \../routes
  \./Input
}

# destructure only what's needed
{header,form,button,div} = DOM

module.exports = component \Header ({after-save=(->), save-cursor, name, title-cursor}) ->
    on-key-up = ->
      if it.key-code is 13
        it.current-target.value = '' # clear input
        title-cursor.update -> ''    # reset cursor

    on-click = -> # save todo
      if title = title-cursor.deref!
        date = new Date!get-time!
        todo = {title, -completed, name, date}
        key  = uuid.v4!
        save-cursor.set key, Immutable.fromJS todo # add
        after-save key, todo

    header do
      class-name: \header
      form do
        on-submit: ~> it.prevent-default!
        div do
          class-name: \clip
          Input {cursor:title-cursor, tab-index:2, key:\focus, ref:\focus, placeholder:'What would you like to do today?', on-key-up, +auto-focus, +spell-check, -controlled, +required}
        button {on-click} \Save
