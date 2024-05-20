#  SwiftUI Date Detector

## Premise

Date Pickers are slow and clunky. Heaven forbid you're old like me and have to scroll the year wheel to 1978.

We type faster than we can scroll.

Let's type in our dates rather than spin 3 wheels.

## Completed ✅

- Interprets what you type in and knows what the date value is
- No need for delimiters like "-" or "."; just type the numbers for month, day, and year
- Auto-advancement of the cursor from the month field to day field to year field

## Work In Progress

- February 29 on non-leap years are not rendering correctly. Currently if you enter 02/29/2001, the app determines that 02 is a valid month, 29 is a valid day, and 2001 is a valid year and coloring all 3 TextFields green. The preview - correctly - only shows only "February" - no day, no year - which to me is the safest thing to say is valid. Which should fields should be red? The day or the year? Or both?
- SwiftDate has its own date validation. my app cannot accurately determine if a February 29, 2001. Is there a method I can call to validate a date and have it tell me which parts are invalid? I've been getting by with just `toFormat(:)`; there must be more.
- I want to optionally declare a parameter to `DateViewModel`: `range: (from: Date, to: Date)`. Example: limit the range of accepted dates from Feb 11, 1804 to Jan 29, 2044. Valided dates outside of this range could still render a preview of the date, but disallow the ability to continue in the app. Perhaps the user could receive a helpful message like, "our data set only includes dates from this range: <range here>. please choose a date within the range."

## Date Validation

*what if i enter a "💩🚽" or "13" for the month?*
*what if i enter 02-29-2001? (that is not a valid date as it was not a leap year)*

Validation will likely be a never-ending work in progress. Please refer to `DateViewModelTests` for latest coverage.

As of 2024.05.19, the following cases are covered:

- February 29 on leap years are valid 
- April 31 is not valid (only 30 days in April)
- Day 32 is never valid (no month is ever greater than 31 days)
- 13 is never a valid entry for month (there are only 12 months)
- 32 is never a valid entry for day (no month is ever greater than 31 days)
- You can enter 💩 emojis, but they will never be valid

## Ideas

- animation
- ISO layout (YYYY.MM.DD) <- I'm a fan 😁
- auto-enter leading zero for single digit month or day (ex: for 1/1/2001 user could press [1 tab 1 tab 2001])
- what if you could make the year display even when a single digit for year is provided? the toFormat() parameter will grow and shrink in size with the user's input? single digit year would yield format "MMddy", double digit year would yield format "MMddyy", etc.

## References

### What is the most performant way to determine if a year is a leap year in Swift?

Modulus (0.5s) vs. Calendar Components (38s) [Stack Overflow](
https://stackoverflow.com/questions/73590525/what-is-the-most-performant-way-to-determine-if-a-year-is-a-leap-year-in-swift)

## Contact

I welcome your feedback and comments! And PRs!

LinkedIn: [https://linkedin.com/in/theovora](https://linkedin.com/in/theovora)

Mastodon: [https://iosdev.space/@theevo](https://linkedin.com/in/theovora)

