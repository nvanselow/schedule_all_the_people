# Schedule All the People

Scheduling a group of people made easy!

#### See it in action: https://schedule-all-the-people.herokuapp.com/

### Purpose

This web app was built as a side project to help figure out how to use the
Google Calendar API in a larger project. It was inspired by a problem a colleague
faced. They had to schedule a large group of people and send out invites and
it took a long time and some people were missed.

This app takes a list of emails (optionally first and last names), open blocks
of time for meetings, and the meeting duration. Then, it assigns all the people to
a meeting time block, creates an event in your Google Calendar, and sends an
invite to the people who were added.

### How to Use It

1. Visit https://schedule-all-the-people.herokuapp.com/ (*Note:* It may take a
  while to load on your first visit because it is currently on a free Heroku server
  that shuts down occasionally)
2. Log in using your Google Account
3. Create a Group

  <img src="/readme_gifs/add_a_group.gif" width="150">
  - You can add individual people via their email
  - Or you can add a list of emails that are separated by commas or semicolons
4. Create an event
  - <img src="/readme_gifs/create_an_event.gif" width="350">
  - Give a name to your event
  - Choose the group of people you want to schedule for that event
  - Select which Google Calendar you want the events to appear on. You can choose
  Google Calendar for which you have write access.
  - Choose the duration of the meeting
  - And provide a location for the meetings (e.g., "My Office")
  - Click the "Create Event" button
5. Add blocks of open time for the event
  - <img src="/readme_gifs/create_a_block.gif" width="350" />

6. Click the "Generate Schedule" button
7. Reschedule people as needed
  - <img src="/readme_gifs/reschedule.gif" width="350" />
8. Click "Send Invites" to send out your Google invites and add the meetings to your calendar

## Future Improvements

- Be able to view all slots and remove individual slots in a block
- Allow multiple people to be scheduled in a slot
- Add additional javascript components (perhaps in React) to reduce page refreshes when adding a block.
- Send out a unique URL to potential people to ask for conflicts. Take those conflicts in to account when generating a schedule.
