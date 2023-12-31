public class ConnectApiHelperForMovedChatter {
    public class InvalidParameterException extends Exception {}
    public static String brokerNames;
    private static final Map<String, ConnectApi.MarkupType> supportedMarkup = new Map<String, ConnectApi.MarkupType> {
        'b' => ConnectApi.MarkupType.Bold,
            'code' => ConnectApi.MarkupType.Code,
            'i' => ConnectApi.MarkupType.Italic,
            'li' => ConnectApi.MarkupType.ListItem,
            'ol' => ConnectApi.MarkupType.OrderedList,
            'p' => ConnectApi.MarkupType.Paragraph,
            's' => ConnectApi.MarkupType.Strikethrough,
            'u' => ConnectApi.MarkupType.Underline,
            'ul' => ConnectApi.MarkupType.UnorderedList
            };
                
                /**
* Posts a feed item with @-mentions using an @-mention formatting syntax.
*
* @param communityId Use either the ID of a community, 'internal', or null.
* @param subjectId The parent of the post. Can be a user ID, a group ID, or a record ID.
* @param textWithMentions The text of the post. You can @-mention a user or group by using
*                         the syntax {ID}, for example: 'Hello {005x0000000URNP}, have you
*                         seen the group {0F9x00000000D7m}?' Links and hashtags will be
*                         automatically parsed if provided.
* @return The posted feed item.
*/
                public static ConnectApi.FeedElement postFeedItemWithMentions(String communityId, String subjectId, String textWithMentions) {
                    return postFeedItemWithSpecialFormatting(communityId, subjectId, textWithMentions, 'textWithMentions');
                }
    
    /**
* Posts a feed item with rich text using HTML tags and inline image formatting syntax.
*
* @param communityId Use either the ID of a community, 'internal', or null.
* @param subjectId The parent of the post. Can be a user ID, a group ID, or a record ID.
* @param textWithMentionsAndRichText The text of the post. You can @-mention a
*                         user or group by using the syntax {ID}, for example:
*                         'Hello {005x0000000URNP}, have you seen the group {0F9x00000000D7m}?'
*                         You can include rich text by using supported HTML tags:
*                         <b>, <i>, <u>, <s>, <ul>, <ol>, <li>, <p>, <code>.
*                         You can include an inline image by using the syntax {img:ID} or
*                         {img:ID:alt text}, for example: 'Have you seen this gorgeous view?
*                         {img:069x00000000D7m:View of the Space Needle from our office.}?'
*                         Links and hashtags will be automatically parsed if provided.
* @return The posted feed item.
*/
    public static ConnectApi.FeedElement postFeedItemWithRichText(String communityId, String subjectId, String textWithMentionsAndRichText) {
        
        return postFeedItemWithSpecialFormatting(communityId, subjectId, textWithMentionsAndRichText, 'textWithMentionsAndRichText');
    }
    
    private static ConnectApi.FeedElement postFeedItemWithSpecialFormatting(String communityId, String subjectId, String formattedText, String textParameterName) {
        if (formattedText == null || formattedText.trim().length() == 0) {
            throw new InvalidParameterException('The ' + textParameterName + ' parameter must be non-empty.');
        }
        
        ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
        messageInput.messageSegments = getMessageSegmentInputs(formattedText);
        
        ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
        input.body = messageInput;
        input.subjectId = subjectId;
        
        return ConnectApi.ChatterFeeds.postFeedElement(communityId, input);
    }
    
    /**
* Posts a comment with @-mentions using an @-mention formatting syntax.
*
* @param communityId Use either the ID of a community, 'internal', or null.
* @param feedItemId The ID of the feed item being commented on.
* @param textWithMentions The text of the comment. You can @-mention a user or group by using
*                         the syntax {ID}, for example: 'Hello {005x0000000URNP}, have you
*                         seen the group {0F9x00000000D7m}?' Links and hashtags will be
*                         automatically parsed if provided.
* @return The posted comment.
*/
    public static ConnectApi.Comment postCommentWithMentions(String communityId, String feedItemId, String textWithMentions) {
        
        if (textWithMentions == null || textWithMentions.trim().length() == 0) {
            throw new InvalidParameterException('The textWithMentions parameter must be non-empty.');
        }
        
        ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
        messageInput.messageSegments = getMessageSegmentInputs(textWithMentions);
        
        ConnectApi.CommentInput input = new ConnectApi.CommentInput();
        input.body = messageInput;
        
        return ConnectApi.ChatterFeeds.postCommentToFeedElement(communityId, feedItemId, input, null);
    }
    Public static String imgggg;
    public static List<ConnectApi.MessageSegmentInput> getMessageSegmentInputs(String inputText) {
        if (inputText == null) {
            throw new InvalidParameterException('The inputText parameter cannot be null.');
        }
        
        List<ConnectApi.MessageSegmentInput> messageSegmentInputs = new List<ConnectApi.MessageSegmentInput>();
        Integer strPos = 0;
        // The pattern for matching mentions, markup begin/end tags, and inline images.
        // The first group matches a 15 or 18 character ID surrounded by {}:
        //   (\\{[a-zA-Z0-9]{15}\\}|\\{[a-zA-Z0-9]{18}\\})
        // The second/third groups match beginning/ending HTML tags: (<[a-zA-Z]*>)|(</[a-zA-Z]*>)
        // The fourth group matches a 15 or 18 character content document ID preceded by "img:",
        //    optionally followed by a string (not containing '}'), and surrounded by {}:
        //    (\\{img:(069[a-zA-Z0-9]{12,15})(:[\\s\\S]*?)?\\})
        // The fifth group matches a 15 or 18 character record ID preceded by "record:" ex:{record:01t3E000002GCm9QAG}
        Pattern globalPattern = Pattern.compile('(\\{[a-zA-Z0-9]{15}\\}|\\{[a-zA-Z0-9]{18}\\})|(<[a-zA-Z]*>)|(</[a-zA-Z]*>)|(\\{img:(069[a-zA-Z0-9]{12,15})(:[\\s\\S]*?)?\\})|(\\{record:([a-zA-Z0-9]){15,18}(:[\\s\\S]*?)?\\})');
        
        Matcher globalMatcher = globalPattern.matcher(inputText);
        System.debug('globalMatcher>>'+globalMatcher);
        while (globalMatcher.find()) {
            String textSegment = inputText.substring(strPos, globalMatcher.start());
            System.debug('textSegment>>'+textSegment);
            imgggg = textSegment.substringBetween('<img', '>');
            System.debug('img>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+imgggg);
            String matchingText = globalMatcher.group();
            System.debug('matchingText>>'+matchingText);
            //String menName;
            /*if(textSegment.startsWith('@'+brokerNames)) {
                // This is a mention id.
                System.debug('Inside the @ and Mention>'+brokerNames);
                String userId = [SELECT ID,Name FROM USER WHERE Name =:brokerNames].Id;
                //String uId =[Select Id,name from User Where name like '%Shashi Yadav%'].Id;
                System.debug('uId>>'+userId);
                ConnectApi.MentionSegmentInput mentionSegmentInput = makeMentionSegmentInput(userId);
                System.debug('mentionSegmentInput======>>>>==='+mentionSegmentInput);
                //menName = mentionSegmentInput;
                messageSegmentInputs.add(mentionSegmentInput);
                strPos = globalMatcher.end();
            }*/
            if (matchingText.startsWith('</img>')) {
                // Add a segment for any accumulated text (which includes unsupported HTML tags).
                addTextSegment(messageSegmentInputs, textSegment);
                System.debug('inside the Image and mention');
                // Strip off the { and }. 
                String innerMatchedText = matchingText.substring(2, matchingText.length() - 1);
                System.debug('innerMatchedText>>'+innerMatchedText);
                if (innerMatchedText.startsWith('img')) {
                    // This is an inline image.
                    System.debug('Inside the image tag');
                    //String[] imageInfo = innerMatchedText.split(':', 3);
                    //String altText = imageInfo.size() == 3 ? imageInfo[2] : null;
                    String imageID = textSegment.substringBetween('//','"');
                    
                    System.debug('imageID>>>'+imageID);
                    ConnectApi.InlineImageSegmentInput inlineImageSegmentInput = makeInlineImageSegmentInput(imageID, 'altText');
                    messageSegmentInputs.add(inlineImageSegmentInput);
                    strPos = globalMatcher.end();
                }
               /* else if (innerMatchedText.startsWith('record:')) {
                    // Inline record
                    String[] recordInfo = innerMatchedText.split(':');
                    ConnectApi.EntityLinkSegmentInput entityLinkSegmentInput = makeEntityLinkSegmentInput(recordInfo[1]);
                    messageSegmentInputs.add(entityLinkSegmentInput);
                    strPos = globalMatcher.end();
                }
                /* else if(textSegment.contains(brokerNames)) {
                // This is a mention id.
                System.debug('Inside the @ and Mention>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+brokerNames);
                ConnectApi.MentionSegmentInput mentionSegmentInput = makeMentionSegmentInput(innerMatchedText);
                messageSegmentInputs.add(mentionSegmentInput);
                strPos = globalMatcher.end();
                }*/
            }
            else {
                // This is an HTML tag.
                boolean isBeginTag = !matchingText.startsWith('</');
                if (isBeginTag) {
                    // Strip off the < and >.
                    String tag = matchingText.substring(1, matchingText.indexOf('>'));
                    if (supportedMarkup.containsKey(tag.toLowerCase())) {
                        // Add a segment for any accumulated text (which includes unsupported HTML tags).
                        addTextSegment(messageSegmentInputs, textSegment);
                        
                        ConnectApi.MarkupBeginSegmentInput markupBeginSegmentInput = makeMarkupBeginSegmentInput(tag);
                        messageSegmentInputs.add(markupBeginSegmentInput);
                        strPos = globalMatcher.end();
                    }
                }
                else { // This is an end tag.
                    // Strip off the </ and >.
                    String tag = matchingText.substring(2, matchingText.indexOf('>'));
                    if (supportedMarkup.containsKey(tag.toLowerCase())) {
                        // Add a segment for any accumulated text (which includes unsupported HTML tags).
                        System.debug('textSegment>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>192'+textSegment);
                        addTextSegment(messageSegmentInputs, textSegment);
                        ConnectApi.MarkupEndSegmentInput markupEndSegmentInput = makeMarkupEndSegmentInput(tag);
                        messageSegmentInputs.add(markupEndSegmentInput);
                        strPos = globalMatcher.end();
                    }
                }
            }
        }
        
        // Take care of any text that comes after the last match.
        if (strPos < inputText.length()) {
            String trailingText = inputText.substring(strPos, inputText.length());
            addTextSegment(messageSegmentInputs, trailingText);
        }
        
        return messageSegmentInputs;
    }
    
    
    private static void addTextSegment(List<ConnectApi.MessageSegmentInput> messageSegmentInputs, String text) {
        if (text != null && text.length() > 0) {
            
            ConnectApi.TextSegmentInput textSegmentInput = makeTextSegmentInput(text);
            messageSegmentInputs.add(textSegmentInput);
        }
    }
    
    private static ConnectApi.TextSegmentInput makeTextSegmentInput(String text) {
        ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
        if(text.contains(('<img'+imgggg+'>'))){
            textSegment.text = text.replaceAll('<img'+imgggg+'>','');
            System.debug('insde the if to replay the image>>'+textSegment.text);
        }else{
            textSegment.text = text;
            System.debug('insde the makeTextSegmentInput>>'+textSegment.text);
        }
        return textSegment;
    }
    
    private static ConnectApi.MentionSegmentInput makeMentionSegmentInput(String mentionId) {
        System.debug('Mention method');
        System.debug('Mention ID>>'+mentionId);
        ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();
        mentionSegment.id = mentionId;
        System.debug('mentionSegment>>>'+mentionSegment);
        return mentionSegment;
    }
    
    // Create entity link segment input using record ID
    // In the chatter post, it will display the Name of the record, with a hyperlink to view the record 
   /* private static ConnectApi.EntityLinkSegmentInput makeEntityLinkSegmentInput(String recordId) {
        ConnectApi.EntityLinkSegmentInput entityLinkSegment = new ConnectApi.EntityLinkSegmentInput();
        entityLinkSegment.entityId = recordId;
        return entityLinkSegment;
    }*/
    
    
    /**
* Create a MarkupBeginSegmentInput corresponding to the tag.  Checking whether the tag is
* supported markup should happen before calling this method.
*/
    private static ConnectApi.MarkupBeginSegmentInput makeMarkupBeginSegmentInput(String tag) {
        ConnectApi.MarkupBeginSegmentInput markupBeginSegment = new ConnectApi.MarkupBeginSegmentInput();
        markupBeginSegment.markupType = supportedMarkup.get(tag.toLowerCase());
        return markupBeginSegment;
    }
    
    /**
* Create a MarkupEndSegmentInput corresponding to the tag.  Checking whether the tag is
* supported markup should happen before calling this method.
*/
    private static ConnectApi.MarkupEndSegmentInput makeMarkupEndSegmentInput(String tag) {
        ConnectApi.MarkupEndSegmentInput markupEndSegment = new ConnectApi.MarkupEndSegmentInput();
        markupEndSegment.markupType = supportedMarkup.get(tag.toLowerCase());
        return markupEndSegment;
    }
    
    private static ConnectApi.InlineImageSegmentInput makeInlineImageSegmentInput(String fileId, String altText) {
        ConnectApi.InlineImageSegmentInput inlineImageSegment = new ConnectApi.InlineImageSegmentInput();
        inlineImageSegment.fileId = fileId;
        if (String.isNotBlank(altText)) {
            inlineImageSegment.altText = altText;
        }
        return inlineImageSegment;
    }
    
    /**
* Takes an output feed body and returns a message body input that matches it.
* This is useful for when you retrieve a feed item or comment and want to either re-post or edit it.
*/
    public static ConnectApi.MessageBodyInput createInputFromBody(ConnectApi.FeedBody body) {
        ConnectApi.MessageBodyInput input = new ConnectApi.MessageBodyInput();
        input.messageSegments = new List<ConnectApi.MessageSegmentInput>();
        
        // Identify newline and replace it with encoded values that MessageSegment will handle correctly.
        String newline = EncodingUtil.urlDecode('%0A', 'UTF-8'); 
        System.debug('new Line >>'+newline);
        for (ConnectApi.MessageSegment segment : body.messageSegments) {
            if (segment instanceof ConnectApi.TextSegment) {
                System.debug('inside the if');
                ConnectApi.TextSegment textOutput = (ConnectApi.TextSegment) segment;
                if (textOutput.text.indexOf(newline) > -1) {
                    // If newline is found, create multiple message segments instead of just a textSegment.
                    /*List<ConnectApi.MessageSegmentInput> newSegments = 
                        ConnectApiHelperForMovedChatter.getMessageSegmentInputs(textOutput.text
                                                                                .replaceAll(newline + newline, '<p>&nbsp;</p>')
                                                                                .replaceAll(newline, '<p></p>'));
                    input.messageSegments.addAll(newSegments);*/ 
                }
                else {
                    
                    List<ConnectApi.MessageSegmentInput> newSegments = 
                        ConnectApiHelperForMovedChatter.getMessageSegmentInputs(textOutput.text
                                                                                .replaceAll('\n' + '\n', '<p>&nbsp;</p>')
                                                                                .replaceAll('\n', '<p></p>'));
                    
                    input.messageSegments.addAll(newSegments); 
                    
                    /*ConnectApi.TextSegmentInput textInput = new ConnectApi.TextSegmentInput();
textInput.text = textOutput.text;
input.messageSegments.add(textInput);*/
                }
            }
            else if (segment instanceof ConnectApi.MentionSegment) {
                ConnectApi.MentionSegment mentionOutput = (ConnectApi.MentionSegment) segment;
                ConnectApi.MentionSegmentInput mentionInput = new ConnectApi.MentionSegmentInput();
                mentionInput.id = mentionOutput.record.id;
                input.messageSegments.add(mentionInput);
            }
            else if (segment instanceof ConnectApi.HashtagSegment) {
                ConnectApi.HashtagSegment hashtagOutput = (ConnectApi.HashtagSegment) segment;
                ConnectApi.HashtagSegmentInput hashtagInput = new ConnectApi.HashtagSegmentInput();
                hashtagInput.tag = hashtagOutput.tag;
                input.messageSegments.add(hashtagInput);
            }
            else if (segment instanceof ConnectApi.LinkSegment) {
                ConnectApi.LinkSegment linkOutput = (ConnectApi.LinkSegment) segment;
                ConnectApi.LinkSegmentInput linkInput = new ConnectApi.LinkSegmentInput();
                linkInput.url = linkOutput.url;
                input.messageSegments.add(linkInput);
            }
            else if (segment instanceof ConnectApi.MarkupBeginSegment) {
                ConnectApi.MarkupBeginSegment markupBeginOutput = (ConnectApi.MarkupBeginSegment) segment;
                ConnectApi.MarkupBeginSegmentInput markupBeginInput = new ConnectApi.MarkupBeginSegmentInput();
                markupBeginInput.markupType = markupBeginOutput.markupType;
                input.messageSegments.add(markupBeginInput);
            }
            else if (segment instanceof ConnectApi.MarkupEndSegment) {
                ConnectApi.MarkupEndSegment markupEndOutput = (ConnectApi.MarkupEndSegment) segment;
                ConnectApi.MarkupEndSegmentInput markupEndInput = new ConnectApi.MarkupEndSegmentInput();
                markupEndInput.markupType = markupEndOutput.markupType;
                input.messageSegments.add(markupEndInput);
            }
            else if (segment instanceof ConnectApi.InlineImageSegment) {
                ConnectApi.InlineImageSegment inlineImageOutput = (ConnectApi.InlineImageSegment) segment;
                ConnectApi.InlineImageSegmentInput inlineImageInput = new ConnectApi.InlineImageSegmentInput();
                inlineImageInput.fileId = inlineImageOutput.thumbnails.fileId;
                inlineImageInput.altText = inlineImageOutput.altText;
                input.messageSegments.add(inlineImageInput);
            }
            else {
                // The other segment types are system-generated and have no corresponding input types.
            }
            
        }
        System.debug('>>>Input<<<<'+input);
        return input;
    }
    
    /**
* Takes an output body and returns a feed item input body that matches it.
* This is useful for when you retrieve a feed item and want to either re-post or edit it.
*/
    public static ConnectApi.FeedItemInput createFeedItemInputFromBody(ConnectApi.FeedBody body) {
        ConnectApi.MessageBodyInput bodyInput = createInputFromBody(body);
        
        ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
        input.body = bodyInput;
        return input;
    }
    
    /**
* Takes an output body and returns a comment input body that matches it.
* This is useful for when you retrieve a comment and want to either re-post or edit it.
*/
    public static ConnectApi.CommentInput createCommentInputFromBody(ConnectApi.FeedBody body) {
        ConnectApi.MessageBodyInput bodyInput = createInputFromBody(body);
        
        ConnectApi.CommentInput input = new ConnectApi.CommentInput();
        input.body = bodyInput;
        return input;
    }
}