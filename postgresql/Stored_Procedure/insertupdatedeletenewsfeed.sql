-- Database Connect
use <databasename>;

-- =================================================
--        File: insertupdatedeletenewsfeed
--     Created: 11/12/2020
--     Updated: 11/17/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Insert update delete new feed
-- =================================================

-- Procedure Drop
drop procedure if exists insertupdatedeletenewsfeed;

-- Procedure Create Or Replace
create or replace procedure  insertupdatedeletenewsfeed(in optionMode text default null, in title text default null, in imageurl text default null, in feedurl text default null, in actualurl text default null, in publishdate text default null, inout status text default null)
as $$
  -- Declare variable
  declare omitOptionMode varchar(255) := '[^a-zA-Z]';
  declare omitTitle varchar(255) := '[^a-zA-Z0-9 !"\#$%&''()*+,\-./:;<=>?@\[\\\]^_‘{|}~¡¢£¥¦§¨©®¯°±´µ¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿıŒœŠšŸŽžƒˆˇ˘˙˚˛ΓΘΣΦΩαδεπστφ–—‘’“”•…€™∂∆∏∑∙√∞∩∫≈≠≡≤≥]';
  declare omitImageURL varchar(255) := '[^a-zA-Z0-9 !"\#$%&''()*+,\-./:;<=>?@\[\\\]^_‘{|}~¡¢£¥¦§¨©®¯°±´µ¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿıŒœŠšŸŽžƒˆˇ˘˙˚˛ΓΘΣΦΩαδεπστφ–—‘’“”•…€™∂∆∏∑∙√∞∩∫≈≠≡≤≥]';
  declare omitFeedURL varchar(768) := '[^a-zA-Z0-9 !"\#$%&''()*+,\-./:;<=>?@\[\\\]^_‘{|}~¡¢£¥¦§¨©®¯°±´µ¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿıŒœŠšŸŽžƒˆˇ˘˙˚˛ΓΘΣΦΩαδεπστφ–—‘’“”•…€™∂∆∏∑∙√∞∩∫≈≠≡≤≥]';
  declare omitActualURL varchar(255) := '[^a-zA-Z0-9 !"\#$%&''()*+,\-./:;<=>?@\[\\\]^_‘{|}~¡¢£¥¦§¨©®¯°±´µ¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿıŒœŠšŸŽžƒˆˇ˘˙˚˛ΓΘΣΦΩαδεπστφ–—‘’“”•…€™∂∆∏∑∙√∞∩∫≈≠≡≤≥]';
  declare omitPublishDate varchar(255) := '[^0-9\-:./ ]';
  declare maxLengthOptionMode int := 255;
  declare maxLengthTitle int := 255;
  declare maxLengthImageURL int := 255;
  declare maxLengthFeedURL int := 768;
  declare maxLengthActualURL int := 255;
  declare maxLengthPublishDate int := 255;
  declare titlestring text := title;
  declare imageurlstring text := imageurl;
  declare feedurlstring text := feedurl;
  declare actualurlstring text := actualurl;
  declare publishdatestring text := publishdate;
  declare code varchar(5) := '00000';
  declare msg text := '';
  declare result text := '';

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
    if titlestring is not null then
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      titlestring := regexp_replace(regexp_replace(titlestring, omitTitle, ' '), '[ ]{2,}', ' ');

      -- Set character limit
      titlestring := trim(substring(titlestring, 1, maxLengthTitle));

      -- Check if empty string
      if titlestring = '' then
        -- Set parameter to null if empty string
        titlestring := nullif(titlestring, '');
      end if;
    end if;

    -- Check if parameter is not null
    if imageurlstring is not null then
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      imageurlstring := regexp_replace(regexp_replace(imageurlstring, omitImageURL, ' '), '[ ]{2,}', ' ');

      -- Set character limit
      imageurlstring := trim(substring(imageurlstring, 1, maxLengthImageURL));

      -- Check if empty string
      if imageurlstring = '' then
        -- Set parameter to null if empty string
        imageurlstring := nullif(imageurlstring, '');
      end if;
    end if;

    -- Check if parameter is not null
    if feedurlstring is not null then
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      feedurlstring := regexp_replace(regexp_replace(feedurlstring, omitFeedURL, ' '), '[ ]{2,}', ' ');

      -- Set character limit
      feedurlstring := trim(substring(feedurlstring, 1, maxLengthFeedURL));

      -- Check if empty string
      if feedurlstring = '' then
        -- Set parameter to null if empty string
        feedurlstring := nullif(feedurlstring, '');
      end if;
    end if;

    -- Check if parameter is not null
    if actualurlstring is not null then
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      actualurlstring := regexp_replace(regexp_replace(actualurlstring, omitActualURL, ' '), '[ ]{2,}', ' ');

      -- Set character limit
      actualurlstring := trim(substring(actualurlstring, 1, maxLengthActualURL));

      -- Check if empty string
      if actualurlstring = '' then
        -- Set parameter to null if empty string
        actualurlstring := nullif(actualurlstring, '');
      end if;
    end if;

    -- Check if parameter is not null
    if publishdatestring is not null then
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      publishdatestring := regexp_replace(regexp_replace(publishdatestring, omitPublishDate, ' '), '[ ]{2,}', ' ');

      -- Set character limit
      publishdatestring := trim(substring(publishdatestring, 1, maxLengthPublishDate));

      -- Check if the parameter cannot be casted into a date time
      if to_timestamp(publishdatestring, 'YYYY-MM-DD HH24:MI:SS') is null then
        -- Set the string as empty to be nulled below
        publishdatestring := '';
      end if;

      -- Check if empty string
      if publishdatestring = '' then
        -- Set parameter to null if empty string
        publishdatestring := nullif(publishdatestring, '');
      end if;
    end if;

    -- Check if option mode is insert news feed
    if optionMode = 'insertNewsFeed' then
      -- Check if parameters are not null
      if titlestring is not null and feedurlstring is not null and publishdatestring is not null then
        -- Check if record does not exist
        if not exists
        (
          -- Select record in question
          select
          nf.title
          from newsfeed nf
          where
          nf.title = titlestring
          group by nf.title
        ) then
          -- Begin begin/except
          begin
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
              titlestring,
              case
                when trim(imageurlstring) = ''
                  then
                    null
                else
                  imageurlstring
              end,
              feedurlstring,
              case
                when trim(actualurlstring) = ''
                  then
                    null
                else
                  actualurlstring
              end,
              to_timestamp(publishdatestring, 'YYYY-MM-DD HH24:MI:SS.US'),
              cast(current_timestamp as timestamp),
              cast(current_timestamp as timestamp)
            );

            -- Set message
            result := concat('{"Status": "Success", "Message": "Record(s) inserted"}');
          exception when others then
            -- Caught exception error
            -- Get diagnostics information
            get stacked diagnostics code = returned_sqlstate, msg = message_text;

            -- Set message
            result := concat('{"Status": "Error", "Message": "', msg, '"}');
          -- End begin/except
          end;
        else
          -- Else a record exist
          -- Set message
          result := concat('{"Status": "Success", "Message": "Record exist"}');
        end if;
      else
        -- Else a parameter was not given
        -- Set message
        result := concat('{"Status": "Error", "Message": "Process halted, title, feed url, and or publish date were not provided"}');
      end if;

      -- Select message
      select
      result into "status";

    -- Check if option mode is update news feed
    elseif optionMode = 'updateNewsFeed' then
      -- Check if parameters are not null
      if titlestring is not null and feedurlstring is not null and publishdatestring is not null then
        -- Check if record exist
        if exists
        (
          -- Select record in question
          select
          nf.title
          from newsfeed nf
          where
          nf.title = titlestring
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
            nf.title = titlestring and
            (
              nf.imageurl = imageurlstring or
              (
                nf.imageurl is null and
                imageurlstring is null
              )
            ) and
            nf.feedurl = feedurlstring and
            (
              nf.actualurl = actualurlstring or
              (
                nf.actualurl is null and
                actualurlstring is null
              )
            ) and
            nf.publish_date = to_timestamp(publishdatestring, 'YYYY-MM-DD HH24:MI:SS.US')
            group by nf.title
          ) then
            -- Begin begin/except
            begin
              -- Update record
              update newsfeed
              set
              imageurl = (case
                  when trim(imageurlstring) = ''
                    then
                      null
                  else
                    imageurlstring
                end
              ),
              feedurl = feedurlstring,
              actualurl = (case
                  when trim(actualurlstring) = ''
                    then
                      null
                  else
                    actualurlstring
                end
              ),
              publish_date = to_timestamp(publishdatestring, 'YYYY-MM-DD HH24:MI:SS.US'),
              modified_date = cast(current_timestamp as timestamp)
              where
              newsfeed.title = titlestring;

              -- Set message
              result := concat('{"Status": "Success", "Message": "Record(s) updated"}');
            exception when others then
              -- Caught exception error
              -- Get diagnostics information
              get stacked diagnostics code = returned_sqlstate, msg = message_text;

              -- Set message
              result := concat('{"Status": "Error", "Message": "', msg, '"}');
            -- End begin/except
            end;
          else
            -- Set message
            result := concat('{"Status": "Success", "Message": "Record already exists"}');
          end if;
        else
          -- Else a record exist
          -- Set message
          result := concat('{"Status": "Error", "Message": "Record does not exist"}');
        end if;
      else
        -- Else a parameter was not given
        -- Set message
        result := concat('{"Status": "Error", "Message": "Process halted, title, feed url, and or publish date were not provided"}');
      end if;

      -- Select message
      select
      result into "status";

    -- Check if option mode is delete news feed
    elseif optionMode = 'deleteNewsFeed' then
      -- Check if parameters are not null
      if titlestring is not null then
        -- Check if record exist
        if exists
        (
          -- Select record in question
          select
          nf.title
          from newsfeed nf
          where
          nf.title = titlestring
          group by nf.title
        ) then
          -- Begin begin/except
          begin
            -- Delete records
            delete
            from newsfeed nf
            where
            nf.title = titlestring;

            -- Set message
            result := concat('{"Status": "Success", "Message": "Record(s) deleted"}');
          exception when others then
            -- Caught exception error
            -- Get diagnostics information
            get stacked diagnostics code = returned_sqlstate, msg = message_text;

            -- Set message
            result := concat('{"Status": "Error", "Message": "', msg, '"}');
          -- End begin/except
          end;
        else
          -- Else a record does not exist
          -- Set message
          result := concat('{"Status": "Success", "Message": "Record does not exist"}');
        end if;
      else
        -- Else a parameter was not given
        -- Set message
        result := concat('{"Status": "Error", "Message": "Process halted, title was not provided"}');
      end if;

      -- Select message
      select
      result into "status";
    end if;
  end; $$
language plpgsql;