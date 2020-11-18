-- Database Connect
use <databasename>;

-- =================================================
--        File: extractnewsfeed
--     Created: 11/12/2020
--     Updated: 11/13/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Extract news feed
-- =================================================

-- Function Drop
drop function if exists extractnewsfeed;

-- Function Create
create or replace function extractnewsfeed(in optionMode text default null, in title text default null, in imageurl text default null, in feedurl text default null, in actualurl text default null, in "limit" text default null, in sort text default null)
returns table (titlereturn text,
  imageurlreturn text,
  feedurlreturn text,
  actualurlreturn text,
  publishdatereturn text
)
as $$
  -- Declare variables
  declare omitOptionMode varchar(255) := '[^a-zA-Z]';
  declare omitTitle varchar(255) := '[^a-zA-Z0-9 !"\#$%&''()*+,\-./:;<=>?@\[\\\]^_‘{|}~¡¢£¥¦§¨©®¯°±´µ¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿıŒœŠšŸŽžƒˆˇ˘˙˚˛ΓΘΣΦΩαδεπστφ–—‘’“”•…€™∂∆∏∑∙√∞∩∫≈≠≡≤≥]';
  declare omitImageURL varchar(255) := '[^a-zA-Z0-9 !"\#$%&''()*+,\-./:;<=>?@\[\\\]^_‘{|}~¡¢£¥¦§¨©®¯°±´µ¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿıŒœŠšŸŽžƒˆˇ˘˙˚˛ΓΘΣΦΩαδεπστφ–—‘’“”•…€™∂∆∏∑∙√∞∩∫≈≠≡≤≥]';
  declare omitFeedURL varchar(255) := '[^a-zA-Z0-9 !"\#$%&''()*+,\-./:;<=>?@\[\\\]^_‘{|}~¡¢£¥¦§¨©®¯°±´µ¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿıŒœŠšŸŽžƒˆˇ˘˙˚˛ΓΘΣΦΩαδεπστφ–—‘’“”•…€™∂∆∏∑∙√∞∩∫≈≠≡≤≥]';
  declare omitActualURL varchar(255) := '[^a-zA-Z0-9 !"\#$%&''()*+,\-./:;<=>?@\[\\\]^_‘{|}~¡¢£¥¦§¨©®¯°±´µ¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿıŒœŠšŸŽžƒˆˇ˘˙˚˛ΓΘΣΦΩαδεπστφ–—‘’“”•…€™∂∆∏∑∙√∞∩∫≈≠≡≤≥]';
  declare omitLimit varchar(255) := '[^0-9\-]';
  declare omitSort varchar(255) := '[^a-zA-Z]';
  declare maxLengthOptionMode int := 255;
  declare maxLengthTitle int := 255;
  declare maxLengthImageURL int := 255;
  declare maxLengthFeedURL int := 768;
  declare maxLengthActualURL int := 255;
  declare maxLengthSort int := 255;
  declare lowerLimit int := 1;
  declare upperLimit int := 100;
  declare defaultLimit int := 25;
  declare dSQL text := '';
  declare dSQLWhere text := '';
  declare countInput int := 0;

  begin
    -- Check if parameter is not null
    if optionMode is not null then
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      optionMode := regexp_replace(regexp_replace(optionMode, omitOptionMode, ' '), '[ ]{2,}', ' ');

      -- Set character limit
      optionMode := trim(substring(optionMode, 1, maxLengthOptionMode));

      -- Check if empty string
      if optionMode = '' then
        -- Set parameter to null if empty string
        optionMode := nullif(optionMode, '');
      end if;
    end if;

    -- Check if parameter is not null
    if title is not null then
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      title := regexp_replace(regexp_replace(title, omitTitle, ' '), '[ ]{2,}', ' ');

      -- Set character limit
      title := trim(substring(title, 1, maxLengthTitle));

      -- Check if empty string
      if title = '' then
        -- Set parameter to null if empty string
        title := nullif(title, '');
      end if;
    end if;

    -- Check if parameter is not null
    if imageurl is not null then
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      imageurl := regexp_replace(regexp_replace(imageurl, omitImageURL, ' '), '[ ]{2,}', ' ');

      -- Set character limit
      imageurl := trim(substring(imageurl, 1, maxLengthImageURL));

      -- Check if empty string
      if imageurl = '' then
        -- Set parameter to null if empty string
        imageurl := nullif(imageurl, '');
      end if;
    end if;

    -- Check if parameter is not null
    if feedurl is not null then
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      feedurl := regexp_replace(regexp_replace(feedurl, omitFeedURL, ' '), '[ ]{2,}', ' ');

      -- Set character limit
      feedurl := trim(substring(feedurl, 1, maxLengthFeedURL));

      -- Check if empty string
      if feedurl = '' then
          -- Set parameter to null if empty string
          feedurl := nullif(feedurl, '');
      end if;
    end if;

    -- Check if parameter is not null
    if actualurl is not null then
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      actualurl := regexp_replace(regexp_replace(actualurl, omitActualURL, ' '), '[ ]{2,}', ' ');

      -- Set character limit
      actualurl := trim(substring(actualurl, 1, maxLengthActualURL));

      -- Check if empty string
      if actualurl = '' then
        -- Set parameter to null if empty string
        actualurl := nullif(actualurl, '');
      end if;
    end if;

    -- Check if parameter is not null
    if "limit" is not null then
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      "limit" := regexp_replace(regexp_replace("limit", omitLimit, ' '), '[ ]{2,}', ' ');

      -- Set character limit
      "limit" := trim("limit");

      -- Check if empty string
      if "limit" = '' then
        -- Set parameter to null if empty string
        "limit" := nullif("limit", '');
      end if;
    end if;

    -- Check if parameter is not null
    if sort is not null then
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      sort := regexp_replace(regexp_replace(sort, omitSort, ' '), '[ ]{2,}', ' ');

      -- Set character limit
      sort := trim(substring(sort, 1, maxLengthSort));

      -- Check if empty string
      if sort = '' then
        -- Set parameter to null if empty string
        sort := nullif(sort, '');
      end if;
    end if;

    -- Check if option mode extract news feed
    if optionMode = 'extractNewsFeed' then
      -- Increment counter
      countInput := countInput + 1;

      -- Check if limit is given
      if "limit" is null or cast("limit" as int) not between lowerLimit and upperLimit then
        -- Set limit to default number
        "limit" := defaultLimit;
      end if;

      -- Check if sort is given
      if sort is null or lower(sort) not in ('desc', 'asc') then
        -- Set sort to default sorting
        sort := 'asc';
      end if;

      -- Select records for processing using the dynamic sql builder containing parameters
      -- Utilize the parentheses for the top portion
      dSQL :=
      'select
      cast(nf.title as text),
      cast(nf.imageurl as text),
      cast(nf.feedurl as text),
      cast(nf.actualurl as text),
      cast(to_char(nf.publish_date, ''YYYY-MM-DD HH24:MI:SS.US'') as text)
      from newsfeed nf';

      -- Check if where clause is given
      if title is not null then
        -- Set variable
        dSQLWhere := concat('nf.title = $', countInput);

        -- Increment counter
        countInput := countInput + 1;
      end if;

      -- Check if where clause is given
      if imageurl is not null then
        -- Check if value is string null
        if lower(imageurl) = 'null' then
          -- Check if dynamic SQL is not empty
          if trim(dSQLWhere) <> trim('') then
            -- Include the next filter into the where clause
            dSQLWhere := concat(dSQLWhere, ' and nf.imageurl is null');
          else
            -- Include the next filter into the where clause
            dSQLWhere := 'nf.imageurl is null';
          end if;
        else
          if trim(dSQLWhere ) <> trim('') then
            -- Include the next filter into the where clause
            dSQLWhere := concat(dSQLWhere, ' and nf.imageurl = $', countInput);
          else
            -- Include the next filter into the where clause
            dSQLWhere := concat('nf.imageurl = $', countInput);
          end if;

          -- Increment counter
          countInput := countInput + 1;
        end if;
      end if;

      -- Check if where clause is given
      if feedurl is not null then
        -- Check if dynamic SQL is not empty
        if trim(dSQLWhere) <> trim('') then
          -- Include the next filter into the where clause
          dSQLWhere := concat(dSQLWhere, ' and nf.feedurl = $', countInput);
        else
          -- Include the next filter into the where clause
          dSQLWhere := concat('nf.feedurl = $', countInput);
        end if;

        -- Increment counter
        countInput := countInput + 1;
      end if;

      -- Check if where clause is given
      if actualurl is not null then
        -- Check if value is string null
        if lower(actualurl) = 'null' then
          -- Check if dynamic SQL is not empty
          if trim(dSQLWhere) <> trim('') then
            -- Include the next filter into the where clause
            dSQLWhere := concat(dSQLWhere, ' and nf.actualurl is null');
          else
            -- Include the next filter into the where clause
            dSQLWhere := 'nf.actualurl is null';
          end if;
        else
          if trim(dSQLWhere ) <> trim('') then
            -- Include the next filter into the where clause
            dSQLWhere := concat(dSQLWhere, ' and nf.actualurl = $', countInput);
          else
            -- Include the next filter into the where clause
            dSQLWhere := concat('nf.actualurl = $', countInput);
          end if;

          -- Increment counter
          countInput := countInput + 1;
        end if;
      end if;

      -- Check if dynamic SQL is not empty
      if trim(dSQLWhere) <> trim('') then
        -- Include the where clause
        dSQLWhere := concat(' where ', dSQLWhere);
      end if;

      -- Set the dynamic string with the where clause and sort option
      dSQL := concat(dSQL, dSQLWhere, ' order by nf.publish_date ', sort, ', nf.title ', sort, ', nf.imageurl ', sort, ', nf.feedurl ', sort, ', nf.actualurl ', sort, ' limit $', countInput);

      -- Increment counter
      countInput := countInput + 1;

      -- Check if parameters were set
      if title is not null and imageurl is null and feedurl is null and actualurl is null then
        -- Important Note: Parameterizated values need to match the placeholders they are matching YNNN
        -- Execute dynamic statement with the parameterized values
        -- Return dynamic sql
        return query execute format(
        '%s',
        dSQL
        ) using cast(title as citext), cast("limit" as int);
      elseif title is not null and imageurl is not null and feedurl is null and actualurl is null then
        -- Check if column is not equal to null
        if imageurl <> 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching YYNN
          -- Execute dynamic statement with the parameterized values
          -- Return dynamic sql
          return query execute format(
          '%s',
          dSQL
          ) using cast(title as citext), cast(imageurl as citext), cast("limit" as int);
        else
          -- Important Note: Parameterizated values need to match the placeholders they are matching YYNN
          -- Execute dynamic statement with the parameterized values
          -- Return dynamic sql
          return query execute format(
          '%s',
          dSQL
          ) using cast(title as citext), cast("limit" as int);
        end if;

      elseif title is not null and imageurl is not null and feedurl is not null and actualurl is null then
        -- Check if column is not equal to null
        if imageurl <> 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching YYYN
          -- Execute dynamic statement with the parameterized values
          -- Return dynamic sql
          return query execute format(
          '%s',
          dSQL
          ) using cast(title as citext), cast(imageurl as citext), cast(feedurl as citext), cast("limit" as int);
        else
          -- Important Note: Parameterizated values need to match the placeholders they are matching YYYN
          -- Execute dynamic statement with the parameterized values
          -- Return dynamic sql
          return query execute format(
          '%s',
          dSQL
          ) using cast(title as citext), cast(feedurl as citext), cast("limit" as int);
        end if;
      elseif title is not null and imageurl is not null and feedurl is null and actualurl is not null then
        -- Check if column is not equal to null
        if imageurl <> 'null' and actualurl <> 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching YYNY
          -- Execute dynamic statement with the parameterized values
          -- Return dynamic sql
          return query execute format(
          '%s',
          dSQL
          ) using cast(title as citext), cast(imageurl as citext), cast(actualurl as citext), cast("limit" as int);
        elseif imageurl = 'null' and actualurl <> 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching YYNY
          -- Execute dynamic statement with the parameterized values
          -- Return dynamic sql
          return query execute format(
          '%s',
          dSQL
          ) using cast(title as citext), cast(actualurl as citext), cast("limit" as int);
        elseif imageurl <> 'null' and actualurl = 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching YYNY
          -- Execute dynamic statement with the parameterized values
          -- Return dynamic sql
          return query execute format(
          '%s',
          dSQL
          ) using cast(title as citext), cast(imageurl as citext), cast("limit" as int);
        else
          -- Important Note: Parameterizated values need to match the placeholders they are matching YYNY
          -- Execute dynamic statement with the parameterized values
          -- Return dynamic sql
          return query execute format(
          '%s',
          dSQL
          ) using cast(title as citext), cast("limit" as int);
        end if;
      elseif title is not null and imageurl is null and feedurl is not null and actualurl is not null then
        -- Check if column is not equal to null
        if actualurl <> 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching YNYY
          -- Execute dynamic statement with the parameterized values
          -- Return dynamic sql
          return query execute format(
          '%s',
          dSQL
          ) using cast(title as citext), cast(feedurl as citext), cast(actualurl as citext), cast("limit" as int);
        else
          -- Important Note: Parameterizated values need to match the placeholders they are matching YNYY
          -- Execute dynamic statement with the parameterized values
          -- Return dynamic sql
          return query execute format(
          '%s',
          dSQL
          ) using cast(title as citext), cast(feedurl as citext), cast("limit" as int);
        end if;
      elseif title is not null and imageurl is null and feedurl is not null and actualurl is null then
        -- Important Note: Parameterizated values need to match the placeholders they are matching YNYN
        -- Execute dynamic statement with the parameterized values
        -- Return dynamic sql
        return query execute format(
        '%s',
        dSQL
        ) using cast(title as citext), cast(feedurl as citext), cast("limit" as int);
      elseif title is not null and imageurl is null and feedurl is null and actualurl is not null then
        -- Check if column is not equal to null
        if actualurl <> 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching YNNY
          -- Execute dynamic statement with the parameterized values
          -- Return dynamic sql
          return query execute format(
          '%s',
          dSQL
          ) using cast(title as citext), cast(actualurl as citext), cast("limit" as int);
        else
          -- Important Note: Parameterizated values need to match the placeholders they are matching YNNY
          -- Execute dynamic statement with the parameterized values
          -- Return dynamic sql
          return query execute format(
          '%s',
          dSQL
          ) using cast(title as citext), cast("limit" as int);
        end if;
      elseif title is null and imageurl is not null and feedurl is not null and actualurl is not null then
        -- Check if column is not equal to null
        if imageurl <> 'null' and actualurl <> 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching NYYY
          -- Execute dynamic statement with the parameterized values
          -- Return dynamic sql
          return query execute format(
          '%s',
          dSQL
          ) using cast(imageurl as citext), cast(feedurl as citext), cast(actualurl as citext), cast("limit" as int);
        elseif imageurl = 'null' and actualurl <> 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching NYYY
          -- Execute dynamic statement with the parameterized values
          -- Return dynamic sql
          return query execute format(
          '%s',
          dSQL
          ) using cast(feedurl as citext), cast(actualurl as citext), cast("limit" as int);
        elseif imageurl <> 'null' and actualurl = 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching NYYY
          -- Execute dynamic statement with the parameterized values
          -- Return dynamic sql
          return query execute format(
          '%s',
          dSQL
          ) using cast(imageurl as citext), cast(feedurl as citext), cast("limit" as int);
        else
          -- Important Note: Parameterizated values need to match the placeholders they are matching NYYY
          -- Execute dynamic statement with the parameterized values
          -- Return dynamic sql
          return query execute format(
          '%s',
          dSQL
          ) using cast(feedurl as citext), cast("limit" as int);
        end if;
      elseif title is null and imageurl is not null and feedurl is not null and actualurl is null then
        -- Check if column is not equal to null
        if imageurl <> 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching NYYN
          -- Execute dynamic statement with the parameterized values
          -- Return dynamic sql
          return query execute format(
          '%s',
          dSQL
          ) using cast(imageurl as citext), cast(feedurl as citext), cast("limit" as int);
        else
          -- Important Note: Parameterizated values need to match the placeholders they are matching NYYN
          -- Execute dynamic statement with the parameterized values
          -- Return dynamic sql
          return query execute format(
          '%s',
          dSQL
          ) using cast(feedurl as citext), cast("limit" as int);
        end if;
      elseif title is null and imageurl is not null and feedurl is null and actualurl is not null then
        -- Check if column is not equal to null
        if imageurl <> 'null' and actualurl <> 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching NYNY
          -- Execute dynamic statement with the parameterized values
          -- Return dynamic sql
          return query execute format(
          '%s',
          dSQL
          ) using cast(imageurl as citext), cast(actualurl as citext), cast("limit" as int);
        elseif imageurl = 'null' and actualurl <> 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching NYNY
          -- Execute dynamic statement with the parameterized values
          -- Return dynamic sql
          return query execute format(
          '%s',
          dSQL
          ) using cast(actualurl as citext), cast("limit" as int);
        elseif imageurl <> 'null' and actualurl = 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching NYNY
          -- Execute dynamic statement with the parameterized values
          -- Return dynamic sql
          return query execute format(
          '%s',
          dSQL
          ) using cast(imageurl as citext), cast("limit" as int);
        else
          -- Important Note: Parameterizated values need to match the placeholders they are matching NYNY
          -- Execute dynamic statement with the parameterized values
          -- Return dynamic sql
          return query execute format(
          '%s',
          dSQL
          ) using cast("limit" as int);
        end if;

      elseif title is null and imageurl is null and feedurl is not null and actualurl is not null then
        -- Check if column is not equal to null
        if actualurl <> 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching NNYY
          -- Execute dynamic statement with the parameterized values
          -- Return dynamic sql
          return query execute format(
          '%s',
          dSQL
          ) using cast(feedurl as citext), cast(actualurl as citext), cast("limit" as int);
        else
          -- Important Note: Parameterizated values need to match the placeholders they are matching NNYY
          -- Execute dynamic statement with the parameterized values
          -- Return dynamic sql
          return query execute format(
          '%s',
          dSQL
          ) using cast(feedurl as citext), cast("limit" as int);
        end if;

      elseif title is null and imageurl is not null and feedurl is null and actualurl is null then
        -- Check if column is not equal to null
        if imageurl <> 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching NYNN
          -- Execute dynamic statement with the parameterized values
          -- Return dynamic sql
          return query execute format(
          '%s',
          dSQL
          ) using cast(imageurl as citext), cast("limit" as int);
        else
          -- Important Note: Parameterizated values need to match the placeholders they are matching NYNN
          -- Execute dynamic statement with the parameterized values
          -- Return dynamic sql
          return query execute format(
          '%s',
          dSQL
          ) using cast("limit" as int);
        end if;

      elseif title is null and imageurl is null and feedurl is not null and actualurl is null then
        -- Important Note: Parameterizated values need to match the placeholders they are matching NNYN
        -- Execute dynamic statement with the parameterized values
        -- Return dynamic sql
        return query execute format(
        '%s',
        dSQL
        ) using cast(feedurl as citext), cast("limit" as int);

      elseif title is null and imageurl is null and feedurl is null and actualurl is not null then
        -- Check if column is not equal to null
        if actualurl <> 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching NNNY
          -- Execute dynamic statement with the parameterized values
          -- Return dynamic sql
          return query execute format(
          '%s',
          dSQL
          ) using cast(actualurl as citext), cast("limit" as int);
        else
          -- Important Note: Parameterizated values need to match the placeholders they are matching NNNY
          -- Execute dynamic statement with the parameterized values
          -- Return dynamic sql
          return query execute format(
          '%s',
          dSQL
          ) using cast("limit" as int);
        end if;

      elseif title is not null and imageurl is not null and feedurl is not null and actualurl is not null then
        -- Check if column is not equal to null
        if imageurl <> 'null' and actualurl <> 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching YYYY
          -- Execute dynamic statement with the parameterized values
          -- Return dynamic sql
          return query execute format(
          '%s',
          dSQL
          ) using cast(title as citext), cast(imageurl as citext), cast(feedurl as citext), cast(actualurl as citext), cast("limit" as int);
        elseif imageurl = 'null' and actualurl <> 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching YYYY
          -- Execute dynamic statement with the parameterized values
          -- Return dynamic sql
          return query execute format(
          '%s',
          dSQL
          ) using cast(title as citext), cast(feedurl as citext), cast(actualurl as citext), cast("limit" as int);
        elseif imageurl <> 'null' and actualurl = 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching YYYY
          -- Execute dynamic statement with the parameterized values
          -- Return dynamic sql
          return query execute format(
          '%s',
          dSQL
          ) using cast(title as citext), cast(imageurl as citext), cast(feedurl as citext), cast("limit" as int);
        else
          -- Important Note: Parameterizated values need to match the placeholders they are matching YYYY
          -- Execute dynamic statement with the parameterized values
          -- Return dynamic sql
          return query execute format(
          '%s',
          dSQL
          ) using cast(title as citext), cast(feedurl as citext), cast("limit" as int);
        end if;

      else
        -- Else execute default statement NNNN
        -- Important Note: Parameterizated values need to match the placeholders they are matching
        -- Execute dynamic statement with the parameterized values
        -- Return dynamic sql
        return query execute format(
        '%s',
        dSQL
        ) using cast("limit" as int);
      end if;
    end if;
  end; $$
language plpgsql;