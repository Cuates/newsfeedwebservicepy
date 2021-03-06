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
drop procedure if exists dbo.extractNewsFeed
go

-- =================================================
--       File: extractNewsFeed
--    Created: 10/30/2020
--    Updated: 11/17/2020
-- Programmer: Cuates
--  Update By: Cuates
--    Purpose: Extract News Feed
-- =================================================

-- Procedure Create
create procedure [dbo].[extractNewsFeed]
  -- Add the parameters for the stored procedure here
  @optionMode nvarchar(max),
  @title nvarchar(max) = null,
  @imageurl nvarchar(max) = null,
  @feedurl nvarchar(max) = null,
  @actualurl nvarchar(max) = null,
  @limit nvarchar(max) = null,
  @sort nvarchar(max) = null
as
begin
  -- Set nocount on added to prevent extra result sets from interfering with select statements
  set nocount on

  -- Declare variables
  declare @omitOptionMode as nvarchar(max)
  declare @omitTitle as nvarchar(max)
  declare @omitImageURL as nvarchar(max)
  declare @omitFeedURL as nvarchar(max)
  declare @omitActualURL as nvarchar(max)
  declare @omitLimit as nvarchar(max)
  declare @omitSort as nvarchar(max)
  declare @maxLengthOptionMode as int
  declare @maxLengthTitle as int
  declare @maxLengthImageURL as int
  declare @maxLengthFeedURL as int
  declare @maxLengthActualURL as int
  declare @maxLengthSort as int
  declare @lowerLimit as int
  declare @upperLimit as int
  declare @defaultLimit as int
  declare @dSQL as nvarchar(max)
  declare @dSQLWhere as nvarchar(max) = ''

  -- Set variables
  set @omitOptionMode = N'0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z'
  set @omitTitle = N'a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,0,1,2,3,4,5,6,7,8,9, ,!,",#,$,%,&,'',(,),*,+,,,-,.,/,:,;,<,=,>,?,@,[,],^,_,{,|,},~,¡,¢,£,¥,¦,§,¨,©,®,¯,°,±,´,µ,¿,À,Á,Â,Ã,Ä,Å,Æ,Ç,È,É,Ê,Ë,Ì,Í,Î,Ï,Ð,Ñ,Ò,Ó,Ô,Õ,Ö,×,Ø,Ù,Ú,Û,Ü,Ý,Þ,ß,à,á,â,ã,ä,å,æ,ç,è,é,ê,ë,ì,í,î,ï,ð,ñ,ò,ó,ô,õ,ö,÷,ø,ù,ú,û,ü,ý,þ,ÿ,ı,Œ,œ,Š,š,Ÿ,Ž,ž,ƒ,ˆ,ˇ,˘,˙,˚,˛,Γ,Θ,Σ,Φ,Ω,α,δ,ε,π,σ,τ,φ,–,—,‘,’,“,”,•,…,€,™,∂,∆,∏,∑,∙,√,∞,∩,∫,≈,≠,≡,≤,≥'
  set @omitImageURL = N'a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,0,1,2,3,4,5,6,7,8,9, ,!,",#,$,%,&,'',(,),*,+,,,-,.,/,:,;,<,=,>,?,@,[,],^,_,{,|,},~,¡,¢,£,¥,¦,§,¨,©,®,¯,°,±,´,µ,¿,À,Á,Â,Ã,Ä,Å,Æ,Ç,È,É,Ê,Ë,Ì,Í,Î,Ï,Ð,Ñ,Ò,Ó,Ô,Õ,Ö,×,Ø,Ù,Ú,Û,Ü,Ý,Þ,ß,à,á,â,ã,ä,å,æ,ç,è,é,ê,ë,ì,í,î,ï,ð,ñ,ò,ó,ô,õ,ö,÷,ø,ù,ú,û,ü,ý,þ,ÿ,ı,Œ,œ,Š,š,Ÿ,Ž,ž,ƒ,ˆ,ˇ,˘,˙,˚,˛,Γ,Θ,Σ,Φ,Ω,α,δ,ε,π,σ,τ,φ,–,—,‘,’,“,”,•,…,€,™,∂,∆,∏,∑,∙,√,∞,∩,∫,≈,≠,≡,≤,≥'
  set @omitFeedURL = N'a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,0,1,2,3,4,5,6,7,8,9, ,!,",#,$,%,&,'',(,),*,+,,,-,.,/,:,;,<,=,>,?,@,[,],^,_,{,|,},~,¡,¢,£,¥,¦,§,¨,©,®,¯,°,±,´,µ,¿,À,Á,Â,Ã,Ä,Å,Æ,Ç,È,É,Ê,Ë,Ì,Í,Î,Ï,Ð,Ñ,Ò,Ó,Ô,Õ,Ö,×,Ø,Ù,Ú,Û,Ü,Ý,Þ,ß,à,á,â,ã,ä,å,æ,ç,è,é,ê,ë,ì,í,î,ï,ð,ñ,ò,ó,ô,õ,ö,÷,ø,ù,ú,û,ü,ý,þ,ÿ,ı,Œ,œ,Š,š,Ÿ,Ž,ž,ƒ,ˆ,ˇ,˘,˙,˚,˛,Γ,Θ,Σ,Φ,Ω,α,δ,ε,π,σ,τ,φ,–,—,‘,’,“,”,•,…,€,™,∂,∆,∏,∑,∙,√,∞,∩,∫,≈,≠,≡,≤,≥'
  set @omitActualURL = N'a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,0,1,2,3,4,5,6,7,8,9, ,!,",#,$,%,&,'',(,),*,+,,,-,.,/,:,;,<,=,>,?,@,[,],^,_,{,|,},~,¡,¢,£,¥,¦,§,¨,©,®,¯,°,±,´,µ,¿,À,Á,Â,Ã,Ä,Å,Æ,Ç,È,É,Ê,Ë,Ì,Í,Î,Ï,Ð,Ñ,Ò,Ó,Ô,Õ,Ö,×,Ø,Ù,Ú,Û,Ü,Ý,Þ,ß,à,á,â,ã,ä,å,æ,ç,è,é,ê,ë,ì,í,î,ï,ð,ñ,ò,ó,ô,õ,ö,÷,ø,ù,ú,û,ü,ý,þ,ÿ,ı,Œ,œ,Š,š,Ÿ,Ž,ž,ƒ,ˆ,ˇ,˘,˙,˚,˛,Γ,Θ,Σ,Φ,Ω,α,δ,ε,π,σ,τ,φ,–,—,‘,’,“,”,•,…,€,™,∂,∆,∏,∑,∙,√,∞,∩,∫,≈,≠,≡,≤,≥'
  set @omitLimit = N'-,0,1,2,3,4,5,6,7,8,9'
  set @omitSort = N'A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z'
  set @maxLengthOptionMode = 255
  set @maxLengthTitle = 255
  set @maxLengthImageURL = 255
  set @maxLengthFeedURL = 768
  set @maxLengthActualURL = 255
  set @maxLengthSort = 255
  set @lowerLimit = 1
  set @upperLimit = 100
  set @defaultLimit = 25

  -- Check if parameter is not null
  if @optionMode is not null
    begin
      -- Omit characters
      set @optionMode = dbo.OmitCharacters(@optionMode, @omitOptionMode)

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
      set @title = dbo.OmitCharacters(@title, @omitTitle)

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
      set @imageurl = dbo.OmitCharacters(@imageurl, @omitImageURL)

      -- Set character limit
      set @imageurl = trim(substring(@imageurl, 1, @maxLengthImageURL))

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
      set @feedurl = dbo.OmitCharacters(@feedurl, @omitFeedURL)

      -- Set character limit
      set @feedurl = trim(substring(@feedurl, 1, @maxLengthFeedURL))

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
      set @actualurl = dbo.OmitCharacters(@actualurl, @omitActualURL)

      -- Set character limit
      set @actualurl = trim(substring(@actualurl, 1, @maxLengthActualURL))

      -- Check if empty string
      if @actualurl = ''
        begin
          -- Set parameter to null if empty string
          set @actualurl = nullif(@actualurl, '')
        end
    end

  -- Check if parameter is not null
  if @limit is not null
    begin
      -- Omit characters
      set @limit = dbo.OmitCharacters(@limit, @omitLimit)

      -- Set character limit
      set @limit = trim(@limit)

      -- Check if empty string
      if @limit = ''
        begin
          -- Set parameter to null if empty string
          set @limit = nullif(@limit, '')
        end
    end

  -- Check if parameter is not null
  if @sort is not null
    begin
      -- Omit characters
      set @sort = dbo.OmitCharacters(@sort, @omitSort)

      -- Set character limit
      set @sort = trim(substring(@sort, 1, @maxLengthSort))

      -- Check if empty string
      if @sort = ''
        begin
          -- Set parameter to null if empty string
          set @sort = nullif(@sort, '')
        end
    end

  -- Check if option mode extract news feed
  if @optionMode = 'extractNewsFeed'
    begin
      -- Check if limit is given
      if @limit is null or @limit not between @lowerLimit and @upperLimit
        begin
          -- Set limit to default number
          set @limit = @defaultLimit
        end

      -- Check if sort is given
      if @sort is null or lower(@sort) not in ('desc', 'asc')
        begin
          -- Set sort to default sorting
          set @sort = 'asc'
        end

      -- Select records for processing using the dynamic sql builder containing parameters
      -- Utilize the parentheses for the top portion
      set @dSQL =
      'select
      top (@_limitString)
      nf.title as [Title],
      nf.imageurl as [Image URL],
      nf.feedurl as [Feed URL],
      nf.actualurl as [Actual URL],
      format(nf.publish_date, ''yyyy-MM-dd HH:mm:ss.ffffff'',''en-us'') as [Publish Date]
      from dbo.NewsFeed nf'

      -- Check if where clause is given
      if @title is not null
        begin
          -- Set variable
          set @dSQLWhere = 'nf.title = @_titleString'
        end

      -- Check if where clause is given
      if @imageurl is not null
        begin
          -- Check if value is string null
          if lower(@imageurl) = 'null'
            begin
              -- Check if dynamic SQL is not empty
              if ltrim(rtrim(@dSQLWhere )) <> ltrim(rtrim(''))
                begin
                  -- Include the next filter into the where clause
                  set @dSQLWhere = @dSQLWhere + ' and nf.imageurl is null'
                end
              else
                begin
                  -- Include the next filter into the where clause
                  set @dSQLWhere = 'nf.imageurl is null'
                end
            end
          else
            -- Else proceed with the normal select call
            begin
                  if ltrim(rtrim(@dSQLWhere )) <> ltrim(rtrim(''))
                begin
                  -- Include the next filter into the where clause
                  set @dSQLWhere = @dSQLWhere + ' and nf.imageurl = @_imageurlString'
                end
              else
                begin
                  -- Include the next filter into the where clause
                  set @dSQLWhere = 'nf.imageurl = @_imageurlString'
                end
            end
        end

      -- Check if where clause is given
      if @feedurl is not null
        begin
          -- Check if dynamic SQL is not empty
          if ltrim(rtrim(@dSQLWhere )) <> ltrim(rtrim(''))
            begin
              -- Include the next filter into the where clause
              set @dSQLWhere = @dSQLWhere + ' and nf.feedurl = @_feedurlString'
            end
          else
            begin
              -- Include the next filter into the where clause
              set @dSQLWhere = 'nf.feedurl = @_feedurlString'
            end
        end

      -- Check if where clause is given
      if @actualurl is not null
        begin
          -- Check if value is string null
          if lower(@imageurl) = 'null'
            begin
              -- Check if dynamic SQL is not empty
              if ltrim(rtrim(@dSQLWhere )) <> ltrim(rtrim(''))
                begin
                  -- Include the next filter into the where clause
                  set @dSQLWhere = @dSQLWhere + ' and nf.actualurl is null'
                end
              else
                begin
                  -- Include the next filter into the where clause
                  set @dSQLWhere = 'nf.actualurl is null'
                end
            end
          else
            -- Else proceed with the normal select call
            begin
              -- Check if dynamic SQL is not empty
              if ltrim(rtrim(@dSQLWhere )) <> ltrim(rtrim(''))
                begin
                  -- Include the next filter into the where clause
                  set @dSQLWhere = @dSQLWhere + ' and nf.actualurl = @_actualurlString'
                end
              else
                begin
                  -- Include the next filter into the where clause
                  set @dSQLWhere = 'nf.actualurl = @_actualurlString'
                end
            end
        end

      -- Check if dynamic SQL is not empty
      if ltrim(rtrim(@dSQLWhere )) <> ltrim(rtrim(''))
        begin
          -- Include the where clause
          set @dSQLWhere = ' where ' + @dSQLWhere
        end

      -- Set the dynamic string with the where clause and sort option
      set @dSQL = @dSQL + @dSQLWhere + ' order by nf.publish_date ' + @sort + ', nf.title ' + @sort + ', nf.imageurl ' + @sort + ', nf.feedurl ' + @sort + ', nf.actualurl ' + @sort

      -- Execute dynamic statement with the parameterized values
      -- Important Note: Parameterizated values need to match the parameters they are matching at the top of the script
      exec sp_executesql @dSQL,
      N'@_titleString as nvarchar(255), @_imageurlString as nvarchar(255), @_feedurlString as nvarchar(768), @_actualurlString as nvarchar(255), @_limitString as int',
      @_titleString = @title, @_imageurlString = @imageurl, @_feedurlString = @feedurl, @_actualurlString = @actualurl, @_limitString = @limit
    end
end