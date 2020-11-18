-- Database Connect
use [Media]
go

-- Set ansi nulls
set ansi_nulls on
go

-- Set quoted identifier
set quoted_identifier on
go

-- Procedure Drop
drop procedure if exists dbo.insertupdatedeleteNewsFeed
go

-- ================================================
--       File: insertupdatedeleteNewsFeed
--    Created: 11/05/2020
--    Updated: 11/16/2020
-- Programmer: Cuates
--  Update By: Cuates
--    Purpose: Insert update delete news feed
-- ================================================

-- Procedure Create
create procedure [dbo].[insertupdatedeleteNewsFeed]
  -- Add the parameters for the stored procedure here
  @optionMode nvarchar(max),
  @title nvarchar(max) = null,
  @imageurl nvarchar(max) = null,
  @feedurl nvarchar(max) = null,
  @actualurl nvarchar(max) = null,
  @publishdate nvarchar(max) = null
as
begin
  -- Set nocount on added to prevent extra result sets from interfering with select statements
  set nocount on

  -- Declare variables
  declare @omitOptionMode as nvarchar(max)
  declare @omitTitle as nvarchar(max)
  declare @omitImageurl as nvarchar(max)
  declare @omitFeedurl as nvarchar(max)
  declare @omitActualurl as nvarchar(max)
  declare @omitPublishDate as nvarchar(max)
  declare @maxLengthOptionMode as int
  declare @maxLengthTitle as int
  declare @maxLengthImageurl as int
  declare @maxLengthFeedurl as int
  declare @maxLengthActualurl as int
  declare @maxLengthPublishDate as int
  declare @result as nvarchar(max)

  -- Set variables
  set @omitOptionMode = N'0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z'
  set @omitTitle = N'a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,0,1,2,3,4,5,6,7,8,9, ,!,",#,$,%,&,'',(,),*,+,,,-,.,/,:,;,<,=,>,?,@,[,],^,_,{,|,},~,¡,¢,£,¥,¦,§,¨,©,®,¯,°,±,´,µ,¿,À,Á,Â,Ã,Ä,Å,Æ,Ç,È,É,Ê,Ë,Ì,Í,Î,Ï,Ð,Ñ,Ò,Ó,Ô,Õ,Ö,×,Ø,Ù,Ú,Û,Ü,Ý,Þ,ß,à,á,â,ã,ä,å,æ,ç,è,é,ê,ë,ì,í,î,ï,ð,ñ,ò,ó,ô,õ,ö,÷,ø,ù,ú,û,ü,ý,þ,ÿ,ı,Œ,œ,Š,š,Ÿ,Ž,ž,ƒ,ˆ,ˇ,˘,˙,˚,˛,Γ,Θ,Σ,Φ,Ω,α,δ,ε,π,σ,τ,φ,–,—,‘,’,“,”,•,…,€,™,∂,∆,∏,∑,∙,√,∞,∩,∫,≈,≠,≡,≤,≥'
  set @omitImageurl = N'a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,0,1,2,3,4,5,6,7,8,9, ,!,",#,$,%,&,'',(,),*,+,,,-,.,/,:,;,<,=,>,?,@,[,],^,_,{,|,},~,¡,¢,£,¥,¦,§,¨,©,®,¯,°,±,´,µ,¿,À,Á,Â,Ã,Ä,Å,Æ,Ç,È,É,Ê,Ë,Ì,Í,Î,Ï,Ð,Ñ,Ò,Ó,Ô,Õ,Ö,×,Ø,Ù,Ú,Û,Ü,Ý,Þ,ß,à,á,â,ã,ä,å,æ,ç,è,é,ê,ë,ì,í,î,ï,ð,ñ,ò,ó,ô,õ,ö,÷,ø,ù,ú,û,ü,ý,þ,ÿ,ı,Œ,œ,Š,š,Ÿ,Ž,ž,ƒ,ˆ,ˇ,˘,˙,˚,˛,Γ,Θ,Σ,Φ,Ω,α,δ,ε,π,σ,τ,φ,–,—,‘,’,“,”,•,…,€,™,∂,∆,∏,∑,∙,√,∞,∩,∫,≈,≠,≡,≤,≥'
  set @omitFeedurl = N'a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,0,1,2,3,4,5,6,7,8,9, ,!,",#,$,%,&,'',(,),*,+,,,-,.,/,:,;,<,=,>,?,@,[,],^,_,{,|,},~,¡,¢,£,¥,¦,§,¨,©,®,¯,°,±,´,µ,¿,À,Á,Â,Ã,Ä,Å,Æ,Ç,È,É,Ê,Ë,Ì,Í,Î,Ï,Ð,Ñ,Ò,Ó,Ô,Õ,Ö,×,Ø,Ù,Ú,Û,Ü,Ý,Þ,ß,à,á,â,ã,ä,å,æ,ç,è,é,ê,ë,ì,í,î,ï,ð,ñ,ò,ó,ô,õ,ö,÷,ø,ù,ú,û,ü,ý,þ,ÿ,ı,Œ,œ,Š,š,Ÿ,Ž,ž,ƒ,ˆ,ˇ,˘,˙,˚,˛,Γ,Θ,Σ,Φ,Ω,α,δ,ε,π,σ,τ,φ,–,—,‘,’,“,”,•,…,€,™,∂,∆,∏,∑,∙,√,∞,∩,∫,≈,≠,≡,≤,≥'
  set @omitActualurl = N'a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,0,1,2,3,4,5,6,7,8,9, ,!,",#,$,%,&,'',(,),*,+,,,-,.,/,:,;,<,=,>,?,@,[,],^,_,{,|,},~,¡,¢,£,¥,¦,§,¨,©,®,¯,°,±,´,µ,¿,À,Á,Â,Ã,Ä,Å,Æ,Ç,È,É,Ê,Ë,Ì,Í,Î,Ï,Ð,Ñ,Ò,Ó,Ô,Õ,Ö,×,Ø,Ù,Ú,Û,Ü,Ý,Þ,ß,à,á,â,ã,ä,å,æ,ç,è,é,ê,ë,ì,í,î,ï,ð,ñ,ò,ó,ô,õ,ö,÷,ø,ù,ú,û,ü,ý,þ,ÿ,ı,Œ,œ,Š,š,Ÿ,Ž,ž,ƒ,ˆ,ˇ,˘,˙,˚,˛,Γ,Θ,Σ,Φ,Ω,α,δ,ε,π,σ,τ,φ,–,—,‘,’,“,”,•,…,€,™,∂,∆,∏,∑,∙,√,∞,∩,∫,≈,≠,≡,≤,≥'
  set @omitPublishDate = N' ,-,/,0,1,2,3,4,5,6,7,8,9,:,.'
  set @maxLengthOptionMode = 255
  set @maxLengthTitle = 255
  set @maxLengthImageurl = 255
  set @maxLengthFeedurl = 768
  set @maxLengthActualurl = 255
  set @maxLengthPublishDate = 255
  set @result = ''

  -- Check if parameter is not null
  if @optionMode is not null
    begin
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      set @optionMode = dbo.omitcharacters(@optionMode, @omitOptionMode)

      -- Set character limit
      set @optionMode = trim(substring(@optionMode, 1, @maxLengthOptionMode))

      -- Check if empty string
      if @optionMode = ''
        begin
          -- Set parameter to null if empty string
          set @optionMode = nullif(@optionMode, '')
        end
    end

  -- Check if parameter is not null
  if @title is not null
    begin
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      set @title = dbo.omitcharacters(@title, @omitTitle)

      -- Set character limit
      set @title = trim(substring(@title, 1, @maxLengthTitle))

      -- Check if empty string
      if @title = ''
        begin
          -- Set parameter to null if empty string
          set @title = nullif(@title, '')
        end
    end

  -- Check if parameter is not null
  if @imageurl is not null
    begin
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      set @imageurl = dbo.omitcharacters(@imageurl, @omitImageurl)

      -- Set character limit
      set @imageurl = trim(substring(@imageurl, 1, @maxLengthImageurl))

      -- Check if empty string
      if @imageurl = ''
        begin
          -- Set parameter to null if empty string
          set @imageurl = nullif(@imageurl, '')
        end
    end

  -- Check if parameter is not null
  if @feedurl is not null
    begin
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      set @feedurl = dbo.omitcharacters(@feedurl, @omitFeedurl)

      -- Set character limit
      set @feedurl = trim(substring(@feedurl, 1, @maxLengthFeedurl))

      -- Check if empty string
      if @feedurl = ''
        begin
          -- Set parameter to null if empty string
          set @feedurl = nullif(@feedurl, '')
        end
    end

  -- Check if parameter is not null
  if @actualurl is not null
    begin
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      set @actualurl = dbo.omitcharacters(@actualurl, @omitActualurl)

      -- Set character limit
      set @actualurl = trim(substring(@actualurl, 1, @maxLengthActualurl))

      -- Check if empty string
      if @actualurl = ''
        begin
          -- Set parameter to null if empty string
          set @actualurl = nullif(@actualurl, '')
        end
    end

  -- Check if parameter is not null
  if @publishdate is not null
    begin
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      set @publishdate = dbo.omitcharacters(@publishdate, @omitPublishDate)

      -- Set character limit
      set @publishdate = trim(substring(@publishdate, 1, @maxLengthPublishDate))

      -- Check if the parameter cannot be casted into a date time
      if try_cast(@publishdate as datetime2(6)) is null
        begin
          -- Set the string as empty to be nulled below
          set @publishdate = ''
        end

      -- Check if empty string
      if @publishdate = ''
        begin
          -- Set parameter to null if empty string
          set @publishdate = nullif(@publishdate, '')
        end
    end

  -- Check if option mode is insert news feed
  if @optionMode = 'insertNewsFeed'
    begin
      -- Check if parameters are not null
      if @title is not null and @feedurl is not null and @publishdate is not null
        begin
          -- Check if record exist
          if not exists
          (
            -- Select record in question
            select
            nf.title as [title]
            from dbo.NewsFeed nf
            where
            nf.title = @title
            group by nf.title
          )
            begin
              -- Begin the tranaction
              begin tran
                -- Begin the try block
                begin try
                  -- Insert record
                  insert into dbo.NewsFeed
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
                    @title,
                    case
                      when trim(@imageurl) = ''
                        then
                          null
                      else
                        @imageurl
                    end,
                    @feedurl,
                    case
                      when trim(@actualurl) = ''
                        then
                          null
                      else
                        @actualurl
                    end,
                    cast(@publishdate as datetime2(6)),
                    cast(getdate() as datetime2(6)),
                    cast(getdate() as datetime2(6))
                  )

                  -- Check if there is trans count
                  if @@trancount > 0
                    begin
                      -- Commit transactional statement
                      commit tran
                    end

                  -- Set message
                  set @result = '{"Status": "Success", "Message": "Record inserted"}'
                end try
                -- End try block
                -- Begin catch block
                begin catch
                  -- Check if there is trans count
                  if @@trancount > 0
                    begin
                      -- Rollback to the previous state before the transaction was called
                      rollback
                    end

                  -- Set message
                  set @result = concat('{"Status": "Error", "Message": "', cast(error_message() as nvarchar(max)), '"}')
                end catch
                -- End catch block
            end
          else
            begin
              -- Record already exist
              -- Set message
              set @result = '{"Status": "Success", "Message": "Record already exist"}'
            end
        end
      else
        begin
          -- Set message
          set @result = '{"Status": "Error", "Message": "Process halted, title, feed url, and or publish date were not provided"}'
        end

      -- Select message
      select
      @result as [status]
    end

  -- Else check if option mode is update news feed
  else if @optionMode = 'updateNewsFeed'
    begin
      -- Check if parameters are not null
      if @title is not null and @feedurl is not null and @publishdate is not null
        begin
          -- Check if record exist
          if exists
          (
            -- Select record in question
            select
            nf.title as [title]
            from dbo.NewsFeed nf
            where
            nf.title = @title
            group by nf.title
          )
            begin
              -- Check if record does not exists
              if not exists
              (
                -- Select records
                select
                nf.title as [title]
                from dbo.NewsFeed nf
                where
                nf.title = @title and
                (
                  nf.imageurl = @imageurl or
                  (
                    nf.imageurl is null and
                    @imageurl is null
                  )
                ) and
                nf.feedurl = @feedurl and
                (
                  nf.actualurl = @actualurl or
                  (
                    nf.actualurl is null and
                    @actualurl is null
                  )
                ) and
                nf.publish_date = @publishdate
                group by nf.title
              )
                begin
                  -- Begin the tranaction
                  begin tran
                    -- Begin the try block
                    begin try
                      -- Update record
                      update dbo.NewsFeed
                      set
                      imageurl = (case
                      when trim(@imageurl) = ''
                        then
                          null
                      else
                        @imageurl
                      end),
                      feedurl = @feedurl,
                      actualurl = (case
                      when trim(@actualurl) = ''
                        then
                          null
                      else
                        @actualurl
                      end),
                      publish_date = cast(@publishdate as datetime2(6)),
                      modified_date =  cast(getdate() as datetime2(6))                     
                      where
                      title = @title

                      -- Check if there is trans count
                      if @@trancount > 0
                        begin
                          -- Commit transactional statement
                          commit tran
                        end

                      -- Set message
                      set @result = '{"Status": "Success", "Message": "Record updated"}'
                    end try
                    -- End try block
                    -- Begin catch block
                    begin catch
                      -- Check if there is trans count
                      if @@trancount > 0
                        begin
                          -- Rollback to the previous state before the transaction was called
                          rollback
                        end

                      -- Set message
                      set @result = concat('{"Status": "Error", "Message": "', cast(error_message() as nvarchar(max)), '"}')
                    end catch
                    -- End catch block
                end
              else
                begin
                  -- Set message
                  set @result = '{"Status": "Success", "Message": "Record already exists"}'
                end
            end
          else
            begin
              -- Record does not exist
              -- Set message
              set @result = '{"Status": "Success", "Message": "Record does not exist"}'
            end
        end
      else
        begin
          -- Set message
          set @result = '{"Status": "Error", "Message": "Process halted, title, feed url, and or publish date were not provided"}'
        end

      -- Select message
      select
      @result as [status]
    end

  -- Else check if option mode is delete news feed
  else if @optionMode = 'deleteNewsFeed'
    begin
      -- Check if parameters are not null
      if @title is not null
        begin
          -- Check if record exist
          if exists
          (
            -- Select record in question
            select
            nf.title as [title]
            from dbo.NewsFeed nf
            where
            nf.title = @title
            group by nf.title
          )
            begin
              -- Begin the tranaction
              begin tran
                -- Begin the try block
                begin try
                  -- Delete record
                  delete
                  from dbo.NewsFeed
                  where
                  title = @title

                  -- Check if there is trans count
                  if @@trancount > 0
                    begin
                      -- Commit transactional statement
                      commit tran
                    end

                  -- Set message
                  set @result = '{"Status": "Success", "Message": "Record deleted"}'
                end try
                -- End try block
                -- Begin catch block
                begin catch
                  -- Check if there is trans count
                  if @@trancount > 0
                    begin
                      -- Rollback to the previous state before the transaction was called
                      rollback
                    end

                  -- Set message
                  set @result = concat('{"Status": "Error", "Message": "', cast(error_message() as nvarchar(max)), '"}')
                end catch
                -- End catch block
            end
          else
            begin
              -- Record does not exist
              -- Set message
              set @result = '{"Status": "Success", "Message": "Record does not exist"}'
            end
        end
      else
        begin
          -- Set message
          set @result = '{"Status": "Error", "Message": "Process halted, title was not provided"}'
        end

      -- Select message
      select
      @result as [status]
    end
end