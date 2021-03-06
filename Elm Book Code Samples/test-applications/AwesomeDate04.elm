module AwesomeDate
    exposing
        ( Date
        , Weekday(..)
        , addDays
        , addMonths
        , addYears
        , create
        , day
        , daysInMonth
        , fromISO8601
        , isLeapYear
        , month
        , toDateString
        , toISO8601
        , weekday
        , year
        )


type Date
    = Date { year : Int, month : Int, day : Int }


create : Int -> Int -> Int -> Date
create year month day =
    Date { year = year, month = month, day = day }


year : Date -> Int
year (Date { year }) =
    year


month : Date -> Int
month (Date { month }) =
    month


day : Date -> Int
day (Date { day }) =
    day


isLeapYear : Int -> Bool
isLeapYear year =
    let
        isDivisibleBy n =
            rem year n == 0
    in
    isDivisibleBy 4 && not (isDivisibleBy 100) || isDivisibleBy 400


toDateString : Date -> String
toDateString (Date { year, month, day }) =
    [ month, day, year ]
        |> List.map toString
        |> String.join "/"


addYears : Int -> Date -> Date
addYears years (Date date) =
    Date { date | year = date.year + years }
        |> preventInvalidLeapDates


preventInvalidLeapDates : Date -> Date
preventInvalidLeapDates (Date ({ year, month, day } as date)) =
    if not (isLeapYear year) && month == 2 && day >= 29 then
        Date { date | day = 28 }
    else
        Date date



{- AwesomeDate Helpers -}
{- Adapted from https://github.com/elm-community/elm-time -}
{-
   Copyright (c) 2016, Bogdan Paul Popa
   All rights reserved.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are met:
       * Redistributions of source code must retain the above copyright
         notice, this list of conditions and the following disclaimer.
       * Redistributions in binary form must reproduce the above copyright
         notice, this list of conditions and the following disclaimer in the
         documentation and/or other materials provided with the distribution.
       * Neither the name of the <organization> nor the
         names of its contributors may be used to endorse or promote products
         derived from this software without specific prior written permission.

   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
   ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
   WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
   DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
   DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
   (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
   LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
   ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-}


type Weekday
    = Sunday
    | Monday
    | Tuesday
    | Wednesday
    | Thursday
    | Friday
    | Saturday


addMonths : Int -> Date -> Date
addMonths months (Date date) =
    Date { date | month = date.month + months }
        |> ensureValidDate


addDays : Int -> Date -> Date
addDays days (Date { year, month, day }) =
    (daysFromYearMonthDay year month day + days)
        |> dateFromDays


daysInMonth : Int -> Int -> Int
daysInMonth year month =
    case month of
        2 ->
            if isLeapYear year then
                29
            else
                28

        4 ->
            30

        6 ->
            30

        9 ->
            30

        11 ->
            30

        _ ->
            31


toISO8601 : Date -> String
toISO8601 (Date { year, month, day }) =
    [ toString year, padZero month, padZero day ]
        |> String.join "-"


fromISO8601 : String -> Maybe Date
fromISO8601 input =
    let
        parsed =
            input
                |> String.split "-"
                |> List.map String.toInt
    in
    case parsed of
        [ Ok year, Ok month, Ok day ] ->
            Just (create year month day)

        _ ->
            Nothing


weekday : Date -> Weekday
weekday (Date { year, month, day }) =
    let
        m =
            if month == 1 then
                0
            else if month == 2 then
                3
            else if month == 3 then
                2
            else if month == 4 then
                5
            else if month == 5 then
                0
            else if month == 6 then
                3
            else if month == 7 then
                5
            else if month == 8 then
                1
            else if month == 9 then
                4
            else if month == 10 then
                6
            else if month == 11 then
                2
            else
                4

        y =
            if month < 3 then
                year - 1
            else
                year

        d =
            (y + y // 4 - y // 100 + y // 400 + m + day) % 7
    in
    if d == 0 then
        Sunday
    else if d == 1 then
        Monday
    else if d == 2 then
        Tuesday
    else if d == 3 then
        Wednesday
    else if d == 4 then
        Thursday
    else if d == 5 then
        Friday
    else
        Saturday


ensureValidDate : Date -> Date
ensureValidDate date =
    date
        |> ensureValidMonth
        |> preventInvalidLeapDates


ensureValidMonth : Date -> Date
ensureValidMonth (Date ({ year, month } as date)) =
    if month < 1 || month > 12 then
        let
            monthOffset =
                month - 1

            newMonth =
                (monthOffset % 12) + 1

            newYear =
                year + floor (toFloat monthOffset / 12)
        in
        Date { date | year = newYear, month = newMonth }
    else
        Date date


padZero : Int -> String
padZero =
    toString >> String.padLeft 2 '0'


daysFromYearMonthDay : Int -> Int -> Int -> Int
daysFromYearMonthDay year month day =
    let
        yds =
            daysFromYear year

        mds =
            daysFromYearMonth year month

        dds =
            day - 1
    in
    yds + mds + dds


daysFromYearMonth : Int -> Int -> Int
daysFromYearMonth year month =
    let
        go year month acc =
            if month == 0 then
                acc
            else
                go year (month - 1) (acc + daysInMonth year month)
    in
    go year (month - 1) 0


daysFromYear : Int -> Int
daysFromYear y =
    if y > 0 then
        366
            + ((y - 1) * 365)
            + ((y - 1) // 4)
            - ((y - 1) // 100)
            + ((y - 1) // 400)
    else if y < 0 then
        (y * 365)
            + (y // 4)
            - (y // 100)
            + (y // 400)
    else
        0


yearFromDays : Int -> Int
yearFromDays ds =
    let
        y =
            ds // 365

        d =
            daysFromYear y
    in
    if ds <= d then
        y - 1
    else
        y


dateFromDays : Int -> Date
dateFromDays ds =
    let
        d400 =
            daysFromYear 400

        y400 =
            ds // d400

        d =
            rem ds d400

        year =
            yearFromDays (d + 1)

        leap =
            if isLeapYear year then
                (+) 1
            else
                identity

        doy =
            d - daysFromYear year

        ( month, day ) =
            if doy < 31 then
                ( 1, doy + 1 )
            else if doy < leap 59 then
                ( 2, doy - 31 + 1 )
            else if doy < leap 90 then
                ( 3, doy - leap 59 + 1 )
            else if doy < leap 120 then
                ( 4, doy - leap 90 + 1 )
            else if doy < leap 151 then
                ( 5, doy - leap 120 + 1 )
            else if doy < leap 181 then
                ( 6, doy - leap 151 + 1 )
            else if doy < leap 212 then
                ( 7, doy - leap 181 + 1 )
            else if doy < leap 243 then
                ( 8, doy - leap 212 + 1 )
            else if doy < leap 273 then
                ( 9, doy - leap 243 + 1 )
            else if doy < leap 304 then
                ( 10, doy - leap 273 + 1 )
            else if doy < leap 334 then
                ( 11, doy - leap 304 + 1 )
            else
                ( 12, doy - leap 334 + 1 )
    in
    Date
        { year = year + y400 * 400
        , month = month
        , day = day
        }
