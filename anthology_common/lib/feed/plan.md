## implementing feeds

### data types

#### the feed

a feed is an entity which has the following data:

- **type:** defines what the feed is (RSS, reddit). used to shipn it to the right handler
- **name:** used for display purposes
- **id:** for saving and querying
- **data:** a catch all binary field that may be used by thew handler

##### data gateway

a data gateway is used to persist these items, CURD operations contained are:

- save feed
- delete feed

#### the feed item

a single item ina feed. it includes id, name, isSeen, displayImage. their persistance is handled by the feed handlers

### handlers

the handler interface provides methods to

- get items for a feed
- set items as seen or unseen
- providing a URi for a feed item (for saving)
  for each type of feed, there would be a handler for taking care of it. hendlers work by being provided a feed datatype and working from their. they are responsible for implementing the saving logic for a feed's items.

### server endpoints

| path          | method | action                         |
| ------------- | ------ | ------------------------------ |
| feed          | get    | gets all feeda                 |
| feed/:id      | get    | lists items in a feed          |
| feed          | post   | creates a new feed             |
| feed/:id      | delete | removes a feed                 |
| feed/seen/:id | put    | marks all unseen items as seen |
