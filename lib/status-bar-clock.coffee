{CompositeDisposable} = require 'atom'
StatusBarClockView = require './status-bar-clock-view'

module.exports = StatusBarClock =
  config:
    activateOnStart:
      type: 'string'
      default: 'Remember last setting'
      enum: ['Remember last setting', 'Show on start', 'Don\'t show on start']

  active: false

  activate: (state) ->
    @state = state

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

  serialize:->
    {
      activateOnStart: atom.config.get('status-bar-clock.activateOnStart'),
      active: @active
    }

  toggle: (active = undefined) ->
    active = ! !!@active if !active?

    if active
      console.log 'Clock was toggled on'
      @statusBarClockView.activate()
      @statusBarTile = @statusBar.addRightTile
        item: @statusBarClockView, priority: -1
    else
      @statusBarTile?.destroy()
      @statusBarClockView?.deactivate()

    @active = active

  consumeStatusBar: (statusBar) ->
    @statusBar = statusBar
    # auto activate as soon as status bar activates based on configuration
    @activateOnStart(@state)

  activateOnStart: (state) ->
    switch state.activateOnStart
      when 'Remember last setting' then @toggle state.active
      when 'Show on start' then @toggle true
      else @toggle false
