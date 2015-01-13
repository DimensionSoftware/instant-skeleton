``
var React     = require('react'),
    immstruct = require('immstruct'),
    component = require('omniscient');

var NameInput = component(function (props) {
  var onChange = function (e) {
    props.cursor.update('name', function (name) {
      return e.currentTarget.value;
    });
  };
  return React.DOM.input({ value: props.cursor.get('name'), onChange: onChange });
});

var Welcome = component(function (props) {
  var cursor = props.cursor;

  var guest = cursor.get('guest');
  var name = guest.get('name') ? ", " + guest.get('name') : "";
  return React.DOM.section({},
                           React.DOM.div({}, cursor.get('greeting'), name, "!"),
                           React.DOM.div({}, NameInput(guest)));
});

var structure = immstruct({ greeting: 'Welcome', guest: { name: '' } });

module.exports.name = 'welcome';
module.exports.structure = structure;
module.exports.init = function (el) {
  return render();
  structure.on('next-animation-frame', render);

  function render () {
    return Welcome(structure.cursor());
  };
};
``
