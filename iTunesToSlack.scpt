tell application "iTunes"
	set current_track to null
	set current_artist to null
	set current_album to null
	
	-- Webhook URL
	set slack_webhook to ""
	-- Slack channel
	set slack_channel to "#music"
	-- Your name
	set slack_username to "YourName"
	-- Bot name to append to your name
	set slack_botname to " (Music)"
	
	repeat until application "iTunes" is not running
		set track_name to name of current track
		set track_artist to artist of current track
		set track_album to album of current track
		
		if track_name ≠ current_track and track_artist ≠ current_artist and track_album ≠ current_track then
			set current_track to name of current track
			set current_artist to artist of current track
			set current_album to album of current track
			
			set message to "*Playing*: " & current_track & "
*by*: " & current_artist & "
*from*: " & current_album
			set message_quote to my replace_chars(message, "\"", "'")
			set message_quote to my replace_chars(message_quote, "'", "`")
			set message_quote to my replace_chars(message_quote, "`", "'\\''")
			set payload to "payload={\"channel\": \"" & slack_channel & "\", \"username\": \"" & slack_username & " (Music)\", \"text\": \"" & message_quote & "\", \"icon_emoji\": \":radio:\"}"
			set spacer_payload to "payload={\"channel\": \"" & slack_channel & "\", \"username\": \"----\", \"text\": \" \", \"icon_emoji\": \":musical_note:\"}"
			set curl_cmd to "curl -sS -X POST --data-urlencode '" & payload & "' " & slack_webhook
			log curl_cmd
			do shell script curl_cmd
			do shell script "curl -sS -X POST --data-urlencode '" & spacer_payload & "' " & slack_webhook
		end if
		
		delay 5
	end repeat
end tell

on replace_chars(this_text, search_string, replacement_string)
	set AppleScript's text item delimiters to the search_string
	set the item_list to every text item of this_text
	set AppleScript's text item delimiters to the replacement_string
	set this_text to the item_list as string
	set AppleScript's text item delimiters to ""
	return this_text
end replace_chars
