# README

Congratulations! You've made it to the coding challenge part of the interview for the BriteVerify team at Validity.

At Validity, we invest heavily in our developers. For that reason, we want to make sure we’re only hiring the best engineers; to do that, we have to see how you code and solve problems, not in front of a white board but at a keyboard. This is your opportunity to shine, to show us how good you are and for us to see what we can expect if we were to hire you. You will demonstrate your ability to understand a problem, find a solution, code that solution and present it to us, in terms of code comments, README, and explanations during the in-person interviews.

We're very excited to see what you create. If at any point, you have questions on the exercise or anything is unclear, please don't hesistate to reach out. Let's get started!

## The Problem

This repo comes complete with a dockererized rails api--with a few bugs. It is your job to clone this repo, build the docker image, and find the bugs. In the below sections are an itemized list of tasks we'd like you to complete before submitting the challenge. Additionally, if you find that too easy and are looking for an extra challenge, we encourage you to try out the bonus tasks! They are, of course, in no way required and will not reflect against you.


## The Solution

Given this clone repo, we ask that you push into your own github account. Then create a PR with all of the changes you made so it is easy for us to see the work you've put into this challenge. Feel free to document any changes via comments, writing your own README, etc.

## Dependencies

### Docker

You might be required to create a Docker account if you do not already have one already.

[Docker Tutorial](https://www.docker.com/get-started)
[Install Docker for Mac](https://docs.docker.com/docker-for-mac/)
[Install Docker for Windows](https://docs.docker.com/docker-for-windows/install/)
[Docker-Compose](https://docs.docker.com/compose/) (optional reading)

### Postman

We recommend using Postman for API calls, feel free to use any platform you feel comfortable with.

[Download Postman](https://www.getpostman.com/downloads/)

### Rspec Best Pracices

For those unfamiliar with rspec.

[Better Specs](http://www.betterspecs.org/)

## Initial Setup

To begin, run the following commands after cloning and stepping inside the repo:

```
docker-compose build
docker-compose run --rm --service-ports web bash
./presetup.sh
rails s -p 3000
```
This builds the docker container, starts the container, sets up the database, and starts the rails server.

To get list of currently running docker containers
`docker ps`

This will return a list similar to this:
```
CONTAINER ID        IMAGE                    COMMAND                  CREATED             STATUS              PORTS                     NAMES
186241d08ca4        briteverify_sample_web   "entrypoint.sh bash"     8 minutes ago       Up 8 minutes        0.0.0.0:3000->3000/tcp    briteverify_sample_web_run_b0ef66d0fcff
```

To enter a docker container, use the `CONTAINER ID` or `NAMES`:

- `docker exec -it 186241d08ca4 bash`
- `docker exec -it briteverify_sample_web_run_b0ef66d0fcff bash`

This will allow you to connect to the container you opened in the first step with the `docker-compose run` command.
Once the container is built you can simply do a `docker-compose up` and the rails server will automatically start.

## Notes for getting Docker setup
To get this section running, I had to add to the docker-compose.yml 

```
environment:
  POSTGRES_HOST_AUTH_METHOD: trust
```

Github issue linked below that explains a recent change that seems to have caused this
https://github.com/docker-library/postgres/issues/681


## Explore the App

This application is meant to do a simple validation on email format. It is already set up to handle RESTful requests with the email_verification API. To try out some of the functionality, go to the rails console or in Postman, try a couple of API requests.

Create a new verification via API call:

## Valid Inputs
```
curl -X POST   http://localhost:3000/api/v1/email_verifications   -H 'Content-Type: application/json'   -d '{
    "email_verification": [{
    "address": "tyler.cone@validity.com"
    }], "token": "9869d9db-6629-43fa-b6e6-df9f92d58551"
}'


curl -X POST   http://localhost:3000/api/v1/email_verifications   -H 'Content-Type: application/json'   -d '{
    "email_verification": [{
    "address": "tyler.cone@validity.com"
    }, {
    "address": "tyler.cone@val@@@@@idity.com"
    }, {
    "address": "sam.karam@val@@@idity.com"
    }], "token": "9869d9db-6629-43fa-b6e6-df9f92d58551"
}'
```

## Invalid inputs:

Inputs with more than 10 addresses or no addresses will receive the following output message:
  {"error":"Incorrect number of emails input."}

```
curl -X POST   http://localhost:3000/api/v1/email_verifications   -H 'Content-Type: application/json'   -d '{
    "email_verification": [], "token": "9869d9db-6629-43fa-b6e6-df9f92d58551"
}'

curl -X POST   http://localhost:3000/api/v1/email_verifications   -H 'Content-Type: application/json'   -d '{
    "email_verification": [{
    "address": "tyler1.cone@validity.com"
    },{
    "address": "sam2.cone@validity.com"
    },{
    "address": "sam3.cone@validity.com"
    },{
    "address": "sam4.cone@validity.com"
    },{
    "address": "sam5.cone@validity.com"
    },{
    "address": "sam6.cone@validity.com"
    },{
    "address": "sam7.cone@validity.com"
    },{
    "address": "sam8.cone@validity.com"
    },{
    "address": "dan9.cone@validity.com"
    },{
    "address": "scott10.cone@validity.com"
    },{
    "address": "scott11.cone@val@@idity.com"
    }], "token": "9869d9db-6629-43fa-b6e6-df9f92d58551"
}'
```

Create a new verification via rails console:

`EmailAddress.create(address: 'foo@bar.com').check_status`

It looks like it's working!

Lets try one more command:

`EmailAddress.create(address: 'foobar.com').check_status`

Uh oh! Seems like we have a bug. Let's run our rspec tests and see if we can figure out what happened here. Exit out of the rails console and run rspec:

`rspec .` or `rspec /spec`

Seems like something is not quite right, a test is failing! Please continue on to see the list of tasks.

## The Tasks

Please timebox this challenge to around 2 hours, if you have extra time or would simply like an extra challenge, check out the bonus section! The main tasks are of higher priority, however.

### Task 1

Fix the failing test by implementing verification logic in the `EmailAddress#check_status` method. This is where your creativity can flouish! When you've finished, the rspec tests should pass.

## Solution Explanation:
I kept this simple and chose to use the built in ruby REGEX, "EMAIL_REGEXP" to validate the emails input.

### Task 2

Currently, the API only accepts one email at a time. It would nice if we had the option to verify a whole list at one time. Implement a way to pass in up to 10 emails at once, and return a status for each.

Bulk API requirements:
- allow anywhere from 1 to 10 email addresses
- return the list of email addresses with their corresponding statuses

Bonus:
- return an error if no email addresses are present
- return an error when more than 10 email addresses are present

## Solution Explanation:
First, I changed the input's accepted format to the following:
```
{
    "email_verification": [{
    "address": "tyler1.cone@validity.com"
    },{
    "address": "sam2.cone@validity.com"
    },{
    "address": "scott11.cone@val@@idity.com"
    }]
}
```
Now the user could submit an array of emails to validate.

Second, I implemented an if check to validate that there are between 1 and 10 addresses in the array.

Lastly, created a for loop that went through each address, created an email validation, and saved the results to an array. Finally, I returned and object with the email addresses and statuses included. 

### Task 3

Turns out our API is open to the public! Let's lock this down following these requirements:

- allow only _active_ users in the database to have access to the API (remeber that users in the database can be active or inactive)
- only existing users can gain access to the API

Again, let your creativity flourish. Be sure to document the new API call in your README updates--we love examples!

## Solution Explanation:
First, I changed the input's accepted format to the following so that a validation token could be included:
```
{
    "email_verification": [{
    "address": "tyler.cone@validity.com"
    }, {
    "address": "tyler.cone@val@@@@@idity.com"
    }, {
    "address": "sam.karam@val@@@idity.com"
    }], "token": "9869d9db-6629-43fa-b6e6-df9f92d58551"
}
```

Next, I wrote a function called require_active_user to validate the user was active and called it using "before_action". 
If the user isn't validated, we render an error object like so:

```
{errors: "Sorry, you are not authorized to use this data."}
```


### Task 4

Let's give this API a UI! Add a basic form for verifiying an email address to the `main_controller` and connect it to either of the APIs. Return the status of the response however you see fit.

## Solution Explanation:
Threw in an HTML form and wired it up to the main_controller. Also, I borrowed some css from the internet to give it a little polish. I also enabled the user to populate the email input using a dynamic url like so:
http://localhost:3000/?address=sam@gmail.com

I did have to remove any references to "data-turbolinks-track" since there were some dependency issues with that.

## Bonus Tasks

The below are listed in no particular order, complete as few or as many as you'd like.

- Due to security and privacy concerns, we do not want to store raw emails in our database. Implement a way to store results, but also not expose raw emails in the database.
- Allow a CSV upload feature in the UI that can verify up to 100 emails (modify the Bulk API to handle a larger load).
- Create a Postman collection to test a valid and invalid endpoint.
- Write rspec tests for the new logic you've implemented in the models and controllers.
