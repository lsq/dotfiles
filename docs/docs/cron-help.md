Cron syntax has five fields separated by a space, and each field represents a unit of time.

┌───────────── minute (0 - 59)
│ ┌───────────── hour (0 - 23)
│ │ ┌───────────── day of the month (1 - 31)
│ │ │ ┌───────────── month (1 - 12 or JAN-DEC)
│ │ │ │ ┌───────────── day of the week (0 - 6 or SUN-SAT)
│ │ │ │ │
│ │ │ │ │
│ │ │ │ │
* * * * *

You can use these operators in any of the five fields:
Operator	Description	Example
*	Any value	15 * * * * runs at every minute 15 of every hour of every day.
,	Value list separator	2,10 4,5 * * * runs at minute 2 and 10 of the 4th and 5th hour of every day.
-	Range of values	30 4-6 * * * runs at minute 30 of the 4th, 5th, and 6th hour.
/	Step values	20/15 * * * * runs every 15 minutes starting from minute 20 through 59 (minutes 20, 35, and 50).

Note

GitHub Actions does not support the non-standard syntax @yearly, @monthly, @weekly, @daily, @hourly, and @reboot.

You can use crontab guru to help generate your cron syntax and confirm what time it will run. To help you get started, there is also a list of crontab guru examples.

Notifications for scheduled workflows are sent to the user who last modified the cron syntax in the workflow file. For more information, see Notifications for workflow runs.
