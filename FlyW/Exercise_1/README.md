# Product implementation

## What to do
Product team has requested us to implement an internal portal working as intranet.  We need to work in a design of the infrastructure and configuration that will allow every person on the company to be able to access the new portal.

The only requirements that we've from Product team is that the application has a web server and a database.

Feel free to upload an `*.md` file, or a drawn schema or whatever you need to explain this set of questions:

# Questions

* Is there anything else we need from Product to implement the portal?
* How we're going to manage backups?
* How we're going to be sure that HA is available in our application
* Our company is international, we have users all around the world, most of our users complain about speed, how do you solve this?
* P&C told us that this application is going to be critical for our business continuity, is there something we need to do about it?

# Bonus questions: Operations on portal

* Because of an error someone deletes the database you have created via AWS console, how are you going to proceed with this error? What actions do your team need take? Which questions do you have here?
* We are going to add a new team to the application that is going to increase traffic. Which people do you need to involve? Any action here?
* How are you going to implement monitoring/observability? Is it needed? Do you need developers or product people involved to take decision here? Why?
* How are you going to deploy new changes to production? Any specific strategy?

## Definition of Done

* Answer the questions above
* Design an schema of the internals of the application

## Considerations

* Ask if you need some clarification ❓
