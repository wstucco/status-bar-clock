{CompositeDisposable} = require 'atom'

module.exports = StatusBarClock =
  active: false

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'status-bar-clock:toggle': => @toggle()

    console.log 'Clock was activated'
  deactivate: ->
    console.log 'Clock was deactivated'

  toggle: ->
    console.log 'Clock was toggled on' if @active
    console.log 'Clock was toggled of' if !@active

    @active = ! !!@active
