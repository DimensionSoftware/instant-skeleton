
require! {
  uuid
  \../routes
  \./Input
}

# destructure only what's needed
{header,form,button,div} = DOM

module.exports = component \Header ({name,title-cur}:props, {after-save, save-cursor}:statics) ->
    on-click = -> # save todo
      if title = title-cur.deref!
        date = new Date!get-time!
        todo = {title, -completed, name, date}
        save-cursor .set uuid.v4!, Immutable.fromJS todo # add
        after-save!
        title-cur.update -> '' # reset ui

    header void [
      form {on-submit:~> it.prevent-default!} [
        div {class-name:\clip} [
          Input title-cur, {key:\focus, ref:\focus, placeholder:'Add an Item ...'}
        ]
        button {on-click}, \Save
      ]
    ]
