{CompositeDisposable} = require 'atom'
StatusBarClockView = require './status-bar-clock-view'

module.exports = StatusBarClock =
  active: false

  activate: (state) ->
    console.log 'Clock was activated'

    @subscriptions = new CompositeDisposable
    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'status-bar-clock:toggle': => @toggle()

    @statusBarClockView = new StatusBarClockView()
    @statusBarClockView.init()

  deactivate: ->
    console.log 'Clock was deactivated'
    @subscriptions.dispose()
    @statusBarClockView.destroy()
    @statusBarTile?.destroy()

  toggle: ->
    if @active
      @statusBarTile.destroy()
      @statusBarClockView.deactivate()
    else
      console.log 'Clock was toggled on'
      @statusBarClockView.activate()
      @statusBarTile = @statusBar.addRightTile
        item: @statusBarClockView, priority: -1

    @active = ! !!@active

  consumeStatusBar: (statusBar) ->
    @statusBar = statusBar
    # auto activate as soon as status bar activates
    @toggle()
