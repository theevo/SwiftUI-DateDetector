#  SwiftUI Date Detector

## Premise

Date Pickers are slow and clunky. Heaven forbid you're old like me and have to scroll the year wheel to 1978.

We type faster than we can scroll.

Let's type in our dates rather than spin 3 wheels.

## Completed ✅

- Interprets what you type in and knows what the date value is
- No need for delimiters like "-" or "."; just type the numbers for month, day, and year
- Auto-advancement of the cursor from the month field to day field to year field

## Ideas

- animation
- validation (what if i enter a "💩🚽" or "13" for the month?)
- internationalization
- auto-enter leading zero for single digit month or day (ex: for 1/1/2001 user could press [1 tab 1 tab 2001])
- what if you could make the year display even when a single digit for year is provided? the toFormat() parameter will grow and shrink in size with the user's input? single digit year would yield format "MMddy", double digit year would yield format "MMddyy", etc.

## References

### What is the most performant way to determine if a year is a leap year in Swift?

Modulus (0.5s) vs. Calendar Components (38s) [Stack Overflow](
https://stackoverflow.com/questions/73590525/what-is-the-most-performant-way-to-determine-if-a-year-is-a-leap-year-in-swift)

## Contact

I welcome your feedback and comments!

LinkedIn: [https://linkedin.com/in/theovora](https://linkedin.com/in/theovora)

Mastodon: [https://iosdev.space/@theevo](https://linkedin.com/in/theovora)

