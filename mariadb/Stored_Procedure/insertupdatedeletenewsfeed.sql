-- Database Connect
use <databasename>;

-- =================================================
--        File: insertupdatedeletenewsfeed
--     Created: 11/05/2020
--     Updated: 11/16/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Insert update delete new feed
-- =================================================

-- Procedure Drop
drop procedure if exists insertupdatedeletenewsfeed;

-- Procedure Create
delimiter //
create procedure `insertupdatedeletenewsfeed`(in optionMode text, in title text, in imageurl text, in feedurl text, in actualurl text, in publishdate text)
  begin
    -- Declare variable
    declare omitOptionMode varchar(255);
    declare omitTitle varchar(255);
    declare omitImageURL varchar(255);
    declare omitFeedURL varchar(768);
    declare omitActualURL varchar(255);
    declare omitPublishDate varchar(255);
    declare maxLengthOptionMode int;
    declare maxLengthTitle int;
    declare maxLengthImageURL int;
    declare maxLengthFeedURL int;
    declare maxLengthActualURL int;
    declare maxLengthPublishDate int;
    declare code varchar(5) default '00000';
    declare msg text;
    declare result text;
    declare successcode varchar(5);

    -- Declare exception handler for failed insert
    declare CONTINUE HANDLER FOR SQLEXCEPTION
      begin
        GET DIAGNOSTICS CONDITION 1
          code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
      end;

    -- Set variable
    set omitOptionMode = '[^a-zA-Z]';
    set omitTitle = '[^a-zA-Z0-9 !"\#$%&\'()*+,\-./:;<=>?@\[\\\]^_{|}~¡¢£¥¦§¨©®¯°±´µ¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿıŒœŠšŸŽžƒˆˇ˘˙˚˛ΓΘΣΦΩαδεπστφ–—‘’“”•…€™∂∆∏∑∙√∞∩∫≈≠≡≤≥]';
    set omitImageURL = '[^a-zA-Z0-9 !"\#$%&\'()*+,\-./:;<=>?@\[\\\]^_{|}~¡¢£¥¦§¨©®¯°±´µ¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿıŒœŠšŸŽžƒˆˇ˘˙˚˛ΓΘΣΦΩαδεπστφ–—‘’“”•…€™∂∆∏∑∙√∞∩∫≈≠≡≤≥]';
    set omitFeedURL = '[^a-zA-Z0-9 !"\#$%&\'()*+,\-./:;<=>?@\[\\\]^_{|}~¡¢£¥¦§¨©®¯°±´µ¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿıŒœŠšŸŽžƒˆˇ˘˙˚˛ΓΘΣΦΩαδεπστφ–—‘’“”•…€™∂∆∏∑∙√∞∩∫≈≠≡≤≥]';
    set omitActualURL = '[^a-zA-Z0-9 !"\#$%&\'()*+,\-./:;<=>?@\[\\\]^_{|}~¡¢£¥¦§¨©®¯°±´µ¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿıŒœŠšŸŽžƒˆˇ˘˙˚˛ΓΘΣΦΩαδεπστφ–—‘’“”•…€™∂∆∏∑∙√∞∩∫≈≠≡≤≥]';
    set omitPublishDate = '[^0-9\-:./ ]';
    set maxLengthOptionMode = 255;
    set maxLengthTitle = 255;
    set maxLengthImageURL = 255;
    set maxLengthFeedURL = 768;
    set maxLengthActualURL = 255;
    set maxLengthPublishDate = 255;
    set successcode = '00000';

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
    if publishdate is not null then
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      set publishdate = regexp_replace(regexp_replace(publishdate, omitPublishDate, ' '), '[ ]{2,}', ' ');

      -- Set character limit
      set publishdate = trim(substring(publishdate, 1, maxLengthPublishDate));

      -- Check if the parameter cannot be casted into a date time
      if str_to_date(publishdate, '%Y-%m-%d %H:%i:%S') is null then
        -- Set the string as empty to be nulled below
        set publishdate = '';
      end if;

      -- Check if empty string
      if publishdate = '' then
        -- Set parameter to null if empty string
        set publishdate = nullif(publishdate, '');
      end if;
    end if;

    -- Check if option mode is insert news feed
    if optionMode = 'insertNewsFeed' then
      -- Check if parameters are not null
      if title is not null and feedurl is not null and publishdate is not null then
        -- Check if record does not exist
        if not exists
        (
          -- Select record in question
          select
          nf.title
          from newsfeed nf
          where
          nf.title = title
          group by nf.title
        ) then
          -- Start the tranaction
          start transaction;
            -- Insert record
            insert into newsfeed
            (
              title,
              imageurl,
              feedurl,
              actualurl,
              publish_date,
              created_date,
              modified_date
            )
            values
            (
              title,
              if(trim(imageurl) = '', null, imageurl),
              feedurl,
              if(trim(actualurl) = '', null, actualurl),
              str_to_date(publishdate, '%Y-%m-%d %H:%i:%s'),
              cast(current_timestamp(6) as datetime),
              cast(current_timestamp(6) as datetime)
            );

            -- Check whether the insert was successful
            if code = successcode then
              -- Commit transactional statement
              commit;

              -- Set message
              set result = concat('{"Status": "Success", "Message": "Record(s) inserted"}');
            else
              -- Rollback to the previous state before the transaction was called
              rollback;

              -- Set message
              set result = concat('{"Status": "Error", "Message": "', msg, '"}');
            end if;
        else
          -- Else a record exist
          -- Set message
          set result = concat('{"Status": "Success", "Message": "Record exist"}');
        end if;
      else
        -- Else a parameter was not given
        -- Set message
        set result = concat('{"Status": "Error", "Message": "Process halted, title, feed url, and or publish date were not provided"}');
      end if;

      -- Select message
      select
      result as `status`;

    -- Check if option mode is update news feed
    elseif optionMode = 'updateNewsFeed' then
      -- Check if parameters are not null
      if title is not null and feedurl is not null and publishdate is not null then
        -- Check if record exist
        if exists
        (
          -- Select record in question
          select
          nf.title
          from newsfeed nf
          where
          nf.title = title
          group by nf.title
        ) then
          -- Check if record does not exists
          if not exists
          (
            -- Select records
            select
            nf.title
            from newsfeed nf
            where
            nf.title = title and
            (
              nf.imageurl = imageurl or
              (
                nf.imageurl is null and
                imageurl is null
              )
            ) and
            nf.feedurl = feedurl and
            (
              nf.actualurl = actualurl or
              (
                nf.actualurl is null and
                actualurl is null
              )
            ) and
            nf.publish_date = publishdate
            group by nf.title
          ) then
            -- Start the tranaction
            start transaction;
              -- Update record
              update newsfeed nf
              set
              nf.imageurl = if(trim(imageurl) = '', null, imageurl),
              nf.feedurl = feedurl,
              nf.actualurl = if(trim(actualurl) = '', null, actualurl),
              nf.publish_date = str_to_date(publishdate, '%Y-%m-%d %H:%i:%s'),
              nf.modified_date = cast(current_timestamp(6) as datetime)
              where
              nf.title = title;

              -- Check whether the insert was successful
              if code = successcode then
                -- Commit transactional statement
                commit;

                -- Set message
                set result = concat('{"Status": "Success", "Message": "Record(s) updated"}');
              else
                -- Rollback to the previous state before the transaction was called
                rollback;

                -- Set message
                set result = concat('{"Status": "Error", "Message": "', msg, '"}');
              end if;
          else
            -- Set message
            set result = concat('{"Status": "Success", "Message": "Record already exists"}');
          end if;
        else
          -- Else a record exist
          -- Set message
          set result = concat('{"Status": "Error", "Message": "Record does not exist"}');
        end if;
      else
        -- Else a parameter was not given
        -- Set message
        set result = concat('{"Status": "Error", "Message": "Process halted, title, feed url, and or publish date were not provided"}');
      end if;

      -- Select message
      select
      result as `status`;

    -- Check if option mode is delete news feed
    elseif optionMode = 'deleteNewsFeed' then
      -- Check if parameters are not null
      if title is not null then
        -- Check if record exist
        if exists
        (
          -- Select record in question
          select
          nf.title
          from newsfeed nf
          where
          nf.title = title
          group by nf.title
        ) then
          -- Start the tranaction
          start transaction;
            -- Delete records
            delete nf
            from newsfeed nf
            where
            nf.title = title;

            -- Check whether the insert was successful
            if code = successcode then
              -- Commit transactional statement
              commit;

              -- Set message
              set result = concat('{"Status": "Success", "Message": "Record(s) Delete"}');
            else
              -- Rollback to the previous state before the transaction was called
              rollback;

              -- Set message
              set result = concat('{"Status": "Error", "Message": "', msg, '"}');
            end if;
        else
          -- Else a record does not exist
          -- Set message
          set result = concat('{"Status": "Success", "Message": "Record does not exist"}');
        end if;
      else
        -- Else a parameter was not given
        -- Set message
        set result = concat('{"Status": "Error", "Message": "Process halted, title was not provided"}');
      end if;

      -- Select message
      select
      result as `status`;
    end if;
  end
// delimiter ;