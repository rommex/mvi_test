# mvi_test
 
Important notes:

1. The `MyHomePage` is the parent of both BlueList and YellowList -- and this is why it should hold
providers for the states of both of these widgets.

This concept is known as 'Lifting up the State' -- I saw many mentions.

In order for one state to update another state, a `context` is injected (line 83).
This context 'knows' about both states because the state is lifted up to the parent.
Otherwise you will get a RUNTIME ERROR.

2. The state is smart, the view is dumb. So to keep to MVVM, the state prepares the data
for display (line 116).

3. Any actions (taps, swipes, etc) performed within a widget must be enum'ed and sent to a single entry
point (line 79). This is clean architecture, you have better control over the event flow plus the enumed actions
provide 'interface' of the state (lines 138-143). This has been taked from @gvoltr's MVI in Kotlin project