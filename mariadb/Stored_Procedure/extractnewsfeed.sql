-- Database Connect
use <databasename>;

-- =================================================
--        File: extractnewsfeed
--     Created: 11/09/2020
--     Updated: 11/17/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Extract news feed
-- =================================================

-- Procedure Drop
drop procedure if exists extractnewsfeed;

-- Procedure Create
delimiter //
create procedure `extractnewsfeed`(in optionMode text, in title text, in imageurl text, in feedurl text, in actualurl text, in `limit` text, in sort text)
  begin
    -- Declare variables
    declare omitOptionMode nvarchar(255);
    declare omitTitle nvarchar(255);
    declare omitImageURL nvarchar(255);
    declare omitFeedURL nvarchar(255);
    declare omitActualURL nvarchar(255);
    declare omitLimit nvarchar(255);
    declare omitSort nvarchar(255);
    declare maxLengthOptionMode int;
    declare maxLengthTitle int;
    declare maxLengthImageURL int;
    declare maxLengthFeedURL int;
    declare maxLengthActualURL int;
    declare maxLengthSort int;
    declare lowerLimit int;
    declare upperLimit int;
    declare defaultLimit int;
    declare code varchar(5) default '00000';
    declare msg text;
    declare result text;
    declare successcode varchar(5);
    declare dSQL text;
    declare dSQLWhere text;

    -- Declare exception handler for failed insert
    declare CONTINUE HANDLER FOR SQLEXCEPTION
      begin
        GET DIAGNOSTICS CONDITION 1
          code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
      end;

    -- Set variables
    set omitOptionMode = '[^a-zA-Z]';
    set omitTitle = '[^a-zA-Z0-9 !"\#$%&\'()*+,\-./:;<=>?@\[\\\]^_‘{|}~¡¢£¥¦§¨©®¯°±´µ¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿıŒœŠšŸŽžƒˆˇ˘˙˚˛ΓΘΣΦΩαδεπστφ–—‘’“”•…€™∂∆∏∑∙√∞∩∫≈≠≡≤≥]';
    set omitImageURL = '[^a-zA-Z0-9 !"\#$%&\'()*+,\-./:;<=>?@\[\\\]^_‘{|}~¡¢£¥¦§¨©®¯°±´µ¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿıŒœŠšŸŽžƒˆˇ˘˙˚˛ΓΘΣΦΩαδεπστφ–—‘’“”•…€™∂∆∏∑∙√∞∩∫≈≠≡≤≥]';
    set omitFeedURL = '[^a-zA-Z0-9 !"\#$%&\'()*+,\-./:;<=>?@\[\\\]^_‘{|}~¡¢£¥¦§¨©®¯°±´µ¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿıŒœŠšŸŽžƒˆˇ˘˙˚˛ΓΘΣΦΩαδεπστφ–—‘’“”•…€™∂∆∏∑∙√∞∩∫≈≠≡≤≥]';
    set omitActualURL = '[^a-zA-Z0-9 !"\#$%&\'()*+,\-./:;<=>?@\[\\\]^_‘{|}~¡¢£¥¦§¨©®¯°±´µ¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿıŒœŠšŸŽžƒˆˇ˘˙˚˛ΓΘΣΦΩαδεπστφ–—‘’“”•…€™∂∆∏∑∙√∞∩∫≈≠≡≤≥]';
    set omitLimit = '[^0-9\-]';
    set omitSort = '[^a-zA-Z]';
    set maxLengthOptionMode = 255;
    set maxLengthTitle = 255;
    set maxLengthImageURL = 255;
    set maxLengthFeedURL = 768;
    set maxLengthActualURL = 255;
    set maxLengthSort = 255;
    set lowerLimit = 1;
    set upperLimit = 100;
    set defaultLimit = 25;
    set successcode = '00000';
    set @dSQL = '';
    set @dSQLWhere = '';
    set @title = null;
    set @imageurl = null;
    set @feedurl = null;
    set @actualurl = null;
    set @`limit` = null;
    set @sort = null;

    -- Check if parameter is not null
    if optionMode is not null then
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      set optionMode = regexp_replace(regexp_replace(optionMode, omitOptionMode, ' '), '[ ]{2,}', ' ');

      -- Set character limit
      set optionMode = trim(substring(optionMode, 1, maxLengthOptionMode));

      -- Check if empty string
      if optionMode = '' then
        -- Set parameter to null if empty string
        set optionMode = nullif(optionMode, '');
      end if;
    end if;

    -- Check if parameter is not null
    if title is not null then
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      set title = regexp_replace(regexp_replace(title, omitTitle, ' '), '[ ]{2,}', ' ');

      -- Set character limit
      set title = trim(substring(title, 1, maxLengthTitle));

      -- Check if empty string
      if title = '' then
        -- Set parameter to null if empty string
        set title = nullif(title, '');
      end if;
    end if;

    -- Check if parameter is not null
    if imageurl is not null then
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      set imageurl = regexp_replace(regexp_replace(imageurl, omitImageURL, ' '), '[ ]{2,}', ' ');

      -- Set character limit
      set imageurl = trim(substring(imageurl, 1, maxLengthImageURL));

      -- Check if empty string
      if imageurl = '' then
        -- Set parameter to null if empty string
        set imageurl = nullif(imageurl, '');
      end if;
    end if;

    -- Check if parameter is not null
    if feedurl is not null then
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      set feedurl = regexp_replace(regexp_replace(feedurl, omitFeedURL, ' '), '[ ]{2,}', ' ');

      -- Set character limit
      set feedurl = trim(substring(feedurl, 1, maxLengthFeedURL));

      -- Check if empty string
      if feedurl = '' then
          -- Set parameter to null if empty string
          set feedurl = nullif(feedurl, '');
      end if;
    end if;

    -- Check if parameter is not null
    if actualurl is not null then
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      set actualurl = regexp_replace(regexp_replace(actualurl, omitActualURL, ' '), '[ ]{2,}', ' ');

      -- Set character limit
      set actualurl = trim(substring(actualurl, 1, maxLengthActualURL));

      -- Check if empty string
      if actualurl = '' then
        -- Set parameter to null if empty string
        set actualurl = nullif(actualurl, '');
      end if;
    end if;

    -- Check if parameter is not null
    if `limit` is not null then
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      set `limit` = regexp_replace(regexp_replace(`limit`, omitLimit, ' '), '[ ]{2,}', ' ');

      -- Set character limit
      set `limit` = trim(`limit`);

      -- Check if empty string
      if `limit` = '' then
        -- Set parameter to null if empty string
        set `limit` = nullif(`limit`, '');
      end if;
    end if;

    -- Check if parameter is not null
    if sort is not null then
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      set sort = regexp_replace(regexp_replace(sort, omitSort, ' '), '[ ]{2,}', ' ');

      -- Set character limit
      set sort = trim(substring(sort, 1, maxLengthSort));

      -- Check if empty string
      if sort = '' then
        -- Set parameter to null if empty string
        set sort = nullif(sort, '');
      end if;
    end if;

    -- Check if option mode extract news feed
    if optionMode = 'extractNewsFeed' then
      -- Check if limit is given
      if `limit` is null or `limit` not between lowerLimit and upperLimit then
        -- Set limit to default number
        set @`limit` = defaultLimit;
      else
        -- Set limit to user input
        set @`limit` = `limit`;
      end if;

      -- Check if sort is given
      if sort is null or lower(sort) not in ('desc', 'asc') then
        -- Set sort to default sorting
        set @sort = 'asc';
      else
        -- Set sort to user input
        set @sort = sort;
      end if;

      -- Select records for processing using the dynamic sql builder containing parameters
      -- Utilize the parentheses for the top portion
      set @dSQL =
      'select
      nf.title as `Title`,
      nf.imageurl as `Image URL`,
      nf.feedurl as `Feed URL`,
      nf.actualurl as `Acutal URL`,
      date_format(nf.publish_date, ''%Y-%m-%d %H:%i:%s.%f'') as `Publish Date`
      from newsfeed nf';

      -- Check if where clause is given
      if title is not null then
        -- Set variable
        set @dSQLWhere = 'nf.title = ?';
        set @title = title;
      end if;

      -- Check if where clause is given
      if imageurl is not null then
        -- Check if value is string null
        if lower(imageurl) = 'null' then
          -- Check if dynamic SQL is not empty
          if trim(@dSQLWhere) <> trim('') then
            -- Include the next filter into the where clause
            set @dSQLWhere = concat(@dSQLWhere, ' nf.imageurl is null');
          else
            -- Include the next filter into the where clause
            set @dSQLWhere = 'nf.imageurl is null';
          end if;
        else
          if trim(@dSQLWhere ) <> trim('') then
            -- Include the next filter into the where clause
            set @dSQLWhere = concat(@dSQLWhere, ' and nf.imageurl = ?');
          else
            -- Include the next filter into the where clause
            set @dSQLWhere = 'nf.imageurl = ?';
          end if;

          -- Set variable
          set @imageurl = imageurl;
        end if;
      end if;

      -- Check if where clause is given
      if feedurl is not null then
        -- Check if dynamic SQL is not empty
        if trim(@dSQLWhere) <> trim('') then
          -- Include the next filter into the where clause
          set @dSQLWhere = concat(@dSQLWhere, ' and nf.feedurl = ?');
        else
          -- Include the next filter into the where clause
          set @dSQLWhere = 'nf.feedurl = ?';
        end if;

        -- Set variable
        set @feedurl = feedurl;
      end if;

      -- Check if where clause is given
      if actualurl is not null then
        -- Check if value is string null
        if lower(actualurl) = 'null' then
          -- Check if dynamic SQL is not empty
          if trim(@dSQLWhere) <> trim('') then
            -- Include the next filter into the where clause
            set @dSQLWhere = concat(@dSQLWhere, ' nf.actualurl is null');
          else
            -- Include the next filter into the where clause
            set @dSQLWhere = 'nf.actualurl is null';
          end if;
        else
          if trim(@dSQLWhere ) <> trim('') then
            -- Include the next filter into the where clause
            set @dSQLWhere = concat(@dSQLWhere, ' and nf.actualurl = ?');
          else
            -- Include the next filter into the where clause
            set @dSQLWhere = 'nf.actualurl = ?';
          end if;

          -- Set variable
          set @actualurl = actualurl;
        end if;
      end if;

      -- Check if dynamic SQL is not empty
      if trim(@dSQLWhere) <> trim('') then
        -- Include the where clause
        set @dSQLWhere = concat(' where ', @dSQLWhere);
      end if;

      -- Set the dynamic string with the where clause and sort option
      set @dSQL = concat(@dSQL, @dSQLWhere, ' order by nf.publish_date ', @sort, ', nf.title ', @sort, ', nf.imageurl ', @sort, ', nf.feedurl ', @sort, ', nf.actualurl ', @sort, ' limit ?');

      -- Prepare the statement
      prepare queryStatement from @dSQL;

      -- Check if parameters were set
      if @title is not null and @imageurl is null and @feedurl is null and @actualurl is null then
        -- Important Note: Parameterizated values need to match the placeholders they are matching YNNN
        -- Execute dynamic statement with the parameterized values
        execute queryStatement using @title, @`limit`;
      elseif @title is not null and @imageurl is not null and @feedurl is null and @actualurl is null then
        -- Check if column is not equal to null
        if imageurl <> 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching YYNN
          -- Execute dynamic statement with the parameterized values
          execute queryStatement using @title, @imageurl, @`limit`;
        else
          -- Important Note: Parameterizated values need to match the placeholders they are matching YYNN
          -- Execute dynamic statement with the parameterized values
          execute queryStatement using @title, @`limit`;
        end if;
      elseif @title is not null and @imageurl is not null and @feedurl is not null and @actualurl is null then
        -- Check if column is not equal to null
        if imageurl <> 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching YYYN
          -- Execute dynamic statement with the parameterized values
          execute queryStatement using @title, @imageurl, @feedurl, @`limit`;
        else
          -- Important Note: Parameterizated values need to match the placeholders they are matching YYYN
          -- Execute dynamic statement with the parameterized values
          execute queryStatement using @title, @feedurl, @`limit`;
        end if;
      elseif @title is not null and @imageurl is not null and @feedurl is null and @actualurl is not null then
        -- Check if column is not equal to null
        if imageurl <> 'null' and actualurl <> 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching YYNY
          -- Execute dynamic statement with the parameterized values
          execute queryStatement using @title, @imageurl, @actualurl, @`limit`;
        elseif imageurl = 'null' and actualurl <> 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching YYNY
          -- Execute dynamic statement with the parameterized values
          execute queryStatement using @title, @actualurl, @`limit`;
        elseif imageurl <> 'null' and actualurl = 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching YYNY
          -- Execute dynamic statement with the parameterized values
          execute queryStatement using @title, @imageurl, @`limit`;
        else
          -- Important Note: Parameterizated values need to match the placeholders they are matching YYNY
          -- Execute dynamic statement with the parameterized values
          execute queryStatement using @title, @`limit`;
        end if;
      elseif @title is not null and @imageurl is null and @feedurl is not null and @actualurl is not null then
        -- Check if column is not equal to null
        if actualurl <> 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching YNYY
          -- Execute dynamic statement with the parameterized values
          execute queryStatement using @title, @feedurl, @actualurl, @`limit`;
        else
          -- Important Note: Parameterizated values need to match the placeholders they are matching YNYY
          -- Execute dynamic statement with the parameterized values
          execute queryStatement using @title, @feedurl, @`limit`;
        end if;
      elseif @title is not null and @imageurl is null and @feedurl is not null and @actualurl is null then
        -- Important Note: Parameterizated values need to match the placeholders they are matching YNYN
        -- Execute dynamic statement with the parameterized values
        execute queryStatement using @title, @feedurl, @`limit`;
      elseif @title is not null and @imageurl is null and @feedurl is null and @actualurl is not null then
        -- Check if column is not equal to null
        if actualurl <> 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching YNNY
          -- Execute dynamic statement with the parameterized values
          execute queryStatement using @title, @actualurl, @`limit`;
        else
          -- Important Note: Parameterizated values need to match the placeholders they are matching YNNY
          -- Execute dynamic statement with the parameterized values
          execute queryStatement using @title, @`limit`;
        end if;
      elseif @title is null and @imageurl is not null and @feedurl is not null and @actualurl is not null then
        -- Check if column is not equal to null
        if imageurl <> 'null' and actualurl <> 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching NYYY
          -- Execute dynamic statement with the parameterized values
          execute queryStatement using @imageurl, @feedurl, @actualurl, @`limit`;
        elseif imageurl = 'null' and actualurl <> 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching NYYY
          -- Execute dynamic statement with the parameterized values
          execute queryStatement using @feedurl, @actualurl, @`limit`;
        elseif imageurl <> 'null' and actualurl = 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching NYYY
          -- Execute dynamic statement with the parameterized values
          execute queryStatement using @imageurl, @feedurl, @`limit`;
        else
          -- Important Note: Parameterizated values need to match the placeholders they are matching NYYY
          -- Execute dynamic statement with the parameterized values
          execute queryStatement using @feedurl, @`limit`;
        end if;
      elseif @title is null and @imageurl is not null and @feedurl is not null and @actualurl is null then
        -- Check if column is not equal to null
        if imageurl <> 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching NYYN
          -- Execute dynamic statement with the parameterized values
          execute queryStatement using @imageurl, @feedurl, @`limit`;
        else
          -- Important Note: Parameterizated values need to match the placeholders they are matching NYYN
          -- Execute dynamic statement with the parameterized values
          execute queryStatement using @feedurl, @`limit`;
        end if;
      elseif @title is null and @imageurl is not null and @feedurl is null and @actualurl is not null then
        -- Check if column is not equal to null
        if imageurl <> 'null' and actualurl <> 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching NYNY
          -- Execute dynamic statement with the parameterized values
          execute queryStatement using @imageurl, @actualurl, @`limit`;
        elseif imageurl = 'null' and actualurl <> 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching NYNY
          -- Execute dynamic statement with the parameterized values
          execute queryStatement using @actualurl, @`limit`;
        elseif imageurl <> 'null' and actualurl = 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching NYNY
          -- Execute dynamic statement with the parameterized values
          execute queryStatement using @imageurl, @`limit`;
        else
          -- Important Note: Parameterizated values need to match the placeholders they are matching NYNY
          -- Execute dynamic statement with the parameterized values
          execute queryStatement using @`limit`;
        end if;
      elseif @title is null and @imageurl is null and @feedurl is not null and @actualurl is not null then
        -- Check if column is not equal to null
        if actualurl <> 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching NNYY
          -- Execute dynamic statement with the parameterized values
          execute queryStatement using @feedurl, @actualurl, @`limit`;
        else
          -- Important Note: Parameterizated values need to match the placeholders they are matching NNYY
          -- Execute dynamic statement with the parameterized values
          execute queryStatement using @feedurl, @`limit`;
        end if;
      elseif @title is null and @imageurl is not null and @feedurl is null and @actualurl is null then
        -- Check if column is not equal to null
        if imageurl <> 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching NYNN
          -- Execute dynamic statement with the parameterized values
          execute queryStatement using @imageurl, @`limit`;
        else
          -- Important Note: Parameterizated values need to match the placeholders they are matching NYNN
          -- Execute dynamic statement with the parameterized values
          execute queryStatement using @`limit`;
        end if;
      elseif @title is null and @imageurl is null and @feedurl is not null and @actualurl is null then
        -- Important Note: Parameterizated values need to match the placeholders they are matching NNYN
        -- Execute dynamic statement with the parameterized values
        execute queryStatement using @feedurl, @`limit`;
      elseif @title is null and @imageurl is null and @feedurl is null and @actualurl is not null then
        -- Check if column is not equal to null
        if actualurl <> 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching NNNY
          -- Execute dynamic statement with the parameterized values
          execute queryStatement using @actualurl, @`limit`;
        else
          -- Important Note: Parameterizated values need to match the placeholders they are matching NNNY
          -- Execute dynamic statement with the parameterized values
          execute queryStatement using @`limit`;
        end if;
      elseif @title is not null and @imageurl is not null and @feedurl is not null and @actualurl is not null then
        -- Check if column is not equal to null
        if imageurl <> 'null' and actualurl <> 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching YYYY
          -- Execute dynamic statement with the parameterized values
          execute queryStatement using @title, @imageurl, @feedurl, @actualurl, @`limit`;
        elseif imageurl = 'null' and actualurl <> 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching YYYY
          -- Execute dynamic statement with the parameterized values
          execute queryStatement using @title, @feedurl, @actualurl, @`limit`;
        elseif imageurl <> 'null' and actualurl = 'null' then
          -- Important Note: Parameterizated values need to match the placeholders they are matching YYYY
          -- Execute dynamic statement with the parameterized values
          execute queryStatement using @title, @imageurl, @feedurl, @`limit`;
        else
          -- Important Note: Parameterizated values need to match the placeholders they are matching YYYY
          -- Execute dynamic statement with the parameterized values
          execute queryStatement using @title, @feedurl, @`limit`;
        end if;
      else
        -- Else execute default statement NNNN
        -- Important Note: Parameterizated values need to match the placeholders they are matching
        -- Execute dynamic statement with the parameterized values
        execute queryStatement using @`limit`;
      end if;

      -- Deallocate prepare statement
      deallocate prepare queryStatement;
    end if;
  end
// delimiter ;