# Fx-you-might-like

Given the state the money markets of late, I can't guarantee you will experience positive feelings from the results returned from this exchange query tool. But here it none-the-less.

# Architecture

Given the cyclic nature of application architecture trends, the simple monolith is probably due a renaissance soon. With that in mind, this app is ahead of the curve, architected as a simple rails monolith. Reusable `Fx` library functions are located in the `/lib` folder and they work by querying a `store` object. In this case, an `ActiveRecord` model takes the store role. Controllers and views follow the Rails Way™.

# Things I would do with more time

Utilise rails models to make form handling more idiomatic - use the `form_for` helpers Luke.

Collaborator tests: the tests for the `Fx` lib are unit tested but the touch points are untested so apis could drift and tests would not pick up that.

Handling errors better - no attempt was made to handle network errors or parsing errors properly.

`Fx::ExchangeRate` should capture the `ActiveRecord::RecordNotFound` exception and raise an exception of it's own to complete the API. Or return a `NoRate` object for null object pattern goodness.

A nicer UI
