//Blocks an attempt to connect before even creating our client datum thing.
world/IsBanned(key,address,computer_id)
	if(ckey(key) in admin_datums)
		return ..()

	//Check if user is whitelisted
	if(config.useckeywhitelist && !check_ckey_whitelisted(ckey(key)))
		log_access("Failed Login: [key] [computer_id] [address] - Pool's Closed")
		message_admins("<span class='notice'>Failed Login: [key] id:[computer_id] ip:[address] - Pool's Closed.</span>")
		return list("reason"="private", "desc"="\nPrivate party. Pool's closed.")

	if(config.private_party && !has_connected(ckey(key)) && !check_ckey_whitelisted(ckey(key)))
		log_access("Failed Login: [key] [computer_id] [address] - Panic Bunker")
		message_admins("<span class='notice'>Failed Login: [key] id:[computer_id] ip:[address] - Panic Bunker.</span>")
		return list("reason"="private", "desc"="\nPrivate party. Pool's closed.")

	//Guest Checking
	if(!config.guests_allowed && IsGuestKey(key))
		log_access("Failed Login: [key] - Guests not allowed")
		message_admins("<span class='notice'>Failed Login: [key] - Guests not allowed</span>")
		return list("reason"="guest", "desc"="\nReason: Guests not allowed. Please sign in with a byond account.")

	if(config.usepopcap)
		var/popcap_value = GLOB.clients.len
		if(popcap_value >= config.popcap && !GLOB.player_list.Find(key))
			log_access("Failed Login: [key] - Population cap reached")
			message_admins("<span class='notice'>Failed Login: [key] - Server is full</span>")
			return list("reason"="popcap", "desc"= "\nReason: Server is full. Try again later.")

	if(config.ban_legacy_system)

		//Ban Checking
		. = CheckBan( ckey(key), computer_id, address )
		if(.)
			log_access("Failed Login: [key] [computer_id] [address] - Banned [.["reason"]]")
			message_admins("<span class='notice'>Failed Login: [key] id:[computer_id] ip:[address] - Banned [.["reason"]]</span>")
			return .

		return ..()	//default pager ban stuff

	else

		var/ckeytext = ckey(key)

		if(!establish_db_connection())
			error("Ban database connection failure. Key [ckeytext] not checked")
			log_misc("Ban database connection failure. Key [ckeytext] not checked")
			return

		var/failedcid = 1
		var/failedip = 1

		var/ipquery = ""
		var/cidquery = ""
		if(address)
			failedip = 0
			ipquery = " OR ip = '[address]' "

		if(computer_id)
			failedcid = 0
			cidquery = " OR computerid = '[computer_id]' "

		var/DBQuery/query = dbcon.NewQuery("SELECT ckey, ip, computerid, a_ckey, reason, expiration_time, duration, bantime, bantype FROM erro_ban WHERE (ckey = '[ckeytext]' [ipquery] [cidquery]) AND (bantype = 'PERMABAN'  OR (bantype = 'TEMPBAN' AND expiration_time > Now())) AND isnull(unbanned)")

		query.Execute()

		while(query.NextRow())
			var/pckey = query.item[1]
			//var/pip = query.item[2]
			//var/pcid = query.item[3]
			var/ackey = query.item[4]
			var/reason = query.item[5]
			var/expiration = query.item[6]
			var/duration = query.item[7]
			var/bantime = query.item[8]
			var/bantype = query.item[9]

			var/expires = ""
			if(text2num(duration) > 0)
				expires = " The ban is for [duration] minutes and expires on [expiration] (server time)."

			var/desc = "\nReason: You, or another user of this computer or connection ([pckey]) is banned from playing here. The ban reason is:\n[reason]\nThis ban was applied by [ackey] on [bantime], [expires]"

			return list("reason"="[bantype]", "desc"="[desc]")

		if (failedcid)
			message_admins("[key] has logged in with a blank computer id in the ban check.")
		if (failedip)
			message_admins("[key] has logged in with a blank ip in the ban check.")
		return ..()	//default pager ban stuff


proc/has_connected(key)
	return fexists("data/player_saves/[copytext(key,1,2)]/[key]/achievements.sav")