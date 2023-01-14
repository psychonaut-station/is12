/proc/rhtml_encode(var/msg)
	msg = replacetext(msg, "<", "&lt;")
	msg = replacetext(msg, ">", "&gt;")
	msg = replacetext(msg, "�", "&#255;")
	return msg

/proc/rhtml_decode(var/msg)
	msg = replacetext(msg, "&gt;", ">")
	msg = replacetext(msg, "&lt;", "<")
	msg = replacetext(msg, "&#255;", "�")
	return msg


//UPPER/LOWER TEXT + RUS TO CP1251 TODO: OVERRIDE uppertext
/proc/ruppertext(text as text)
	text = uppertext(text)
	var/t = ""
	for(var/i = 1, i <= length(text), i++)
		var/a = text2ascii(text, i)
		if (a > 223)
			t += ascii2text(a - 32)
		else if (a == 184)
			t += ascii2text(168)
		else t += ascii2text(a)
	t = replacetext(t,"&#255;","�")
	return t

/proc/rlowertext(text as text)
	text = lowertext(text)
	var/t = ""
	for(var/i = 1, i <= length(text), i++)
		var/a = text2ascii(text, i)
		if (a > 191 && a < 224)
			t += ascii2text(a + 32)
		else if (a == 168)
			t += ascii2text(184)
		else t += ascii2text(a)
	return t


//RUS CONVERTERS
/proc/russian_to_cp1251(var/msg)//CHATBOX
	return replacetext(msg, "�", "&#255;")

/proc/russian_to_utf8(var/msg)//PDA PAPER POPUPS
	return replacetext(msg, "�", "&#1103;")

/proc/utf8_to_cp1251(msg)
	return replacetext(msg, "&#1103;", "&#255;")

/proc/cp1251_to_utf8(msg)
	return replacetext(msg, "&#255;", "&#1103;")

//Prepare text for edit. Replace "y" with "\?" for edition. Don't forget to call post_edit().
/proc/edit_cp1251(msg)
	return replacetext(msg, "&#255;", "\\�")

/proc/edit_utf8(msg)
	return replacetext(msg, "&#1103;", "\\�")

/proc/post_edit_cp1251(msg)
	return replacetext(msg, "\\�", "&#255;")

/proc/post_edit_utf8(msg)
	return replacetext(msg, "\\�", "&#1103;")

//input

/proc/input_cp1251(var/mob/user = usr, var/message, var/title, var/default, var/type = "message")
	var/msg = ""
	switch(type)
		if("message")
			msg = input(user, message, title, edit_cp1251(default)) as message
		if("text")
			msg = input(user, message, title, default) as text
	msg = russian_to_cp1251(msg)
	return post_edit_cp1251(msg)

/proc/input_utf8(var/mob/user = usr, var/message, var/title, var/default, var/type = "message")
	var/msg = ""
	switch(type)
		if("message")
			msg = input(user, message, title, edit_utf8(default)) as message
		if("text")
			msg = input(user, message, title, default) as text
	msg = russian_to_utf8(msg)
	return post_edit_utf8(msg)


var/global/list/rkeys = list(
	"�" = "f", "�" = "d", "�" = "u", "�" = "l",
	"�" = "t", "�" = "p", "�" = "b", "�" = "q",
	"�" = "r", "�" = "k", "�" = "v", "�" = "y",
	"�" = "j", "�" = "g", "�" = "h", "�" = "c",
	"�" = "n", "�" = "e", "�" = "a", "�" = "w",
	"�" = "x", "�" = "i", "�" = "o", "�" = "s",
	"�" = "m", "�" = "z"
)

//Transform keys from russian keyboard layout to eng analogues and lowertext it.
/proc/sanitize_key(t)
	t = rlowertext(t)
	if(t in rkeys) return rkeys[t]
	return (t)

//TEXT MODS RUS
/proc/capitalize_cp1251(var/t as text)
	var/s = 2
	if (copytext(t,1,2) == ";")
		s += 1
	else if (copytext(t,1,2) == ":")
		s += 2
	return ruppertext(copytext(t, 1, s)) + copytext(t, s)

/proc/intonation(text)
	if (copytext(text,-1) == "!")
		text = "<b>[text]</b>"
	return text

/proc/rustoutf(text)			//fucking tghui
	text = replacetext(text, "�", "&#x430;")
	text = replacetext(text, "�", "&#x431;")
	text = replacetext(text, "�", "&#x432;")
	text = replacetext(text, "�", "&#x433;")
	text = replacetext(text, "�", "&#x434;")
	text = replacetext(text, "�", "&#x435;")
	text = replacetext(text, "�", "&#x451;")
	text = replacetext(text, "�", "&#x436;")
	text = replacetext(text, "�", "&#x437;")
	text = replacetext(text, "�", "&#x438;")
	text = replacetext(text, "�", "&#x439;")
	text = replacetext(text, "�", "&#x43A;")
	text = replacetext(text, "�", "&#x43B;")
	text = replacetext(text, "�", "&#x43C;")
	text = replacetext(text, "�", "&#x43D;")
	text = replacetext(text, "�", "&#x43E;")
	text = replacetext(text, "�", "&#x43F;")
	text = replacetext(text, "�", "&#x440;")
	text = replacetext(text, "�", "&#x441;")
	text = replacetext(text, "�", "&#x442;")
	text = replacetext(text, "�", "&#x443;")
	text = replacetext(text, "�", "&#x444;")
	text = replacetext(text, "�", "&#x445;")
	text = replacetext(text, "�", "&#x446;")
	text = replacetext(text, "�", "&#x447;")
	text = replacetext(text, "�", "&#x448;")
	text = replacetext(text, "�", "&#x449;")
	text = replacetext(text, "�", "&#x44A;")
	text = replacetext(text, "�", "&#x44B;")
	text = replacetext(text, "�", "&#x44C;")
	text = replacetext(text, "�", "&#x44D;")
	text = replacetext(text, "�", "&#x44E;")
	text = replacetext(text, "�", "&#x44F;")
	text = replacetext(text, "�", "&#x410;")
	text = replacetext(text, "�", "&#x411;")
	text = replacetext(text, "�", "&#x412;")
	text = replacetext(text, "�", "&#x413;")
	text = replacetext(text, "�", "&#x414;")
	text = replacetext(text, "�", "&#x415;")
	text = replacetext(text, "�", "&#x401;")
	text = replacetext(text, "�", "&#x416;")
	text = replacetext(text, "�", "&#x417;")
	text = replacetext(text, "�", "&#x418;")
	text = replacetext(text, "�", "&#x419;")
	text = replacetext(text, "�", "&#x41A;")
	text = replacetext(text, "�", "&#x41B;")
	text = replacetext(text, "�", "&#x41C;")
	text = replacetext(text, "�", "&#x41D;")
	text = replacetext(text, "�", "&#x41E;")
	text = replacetext(text, "�", "&#x41F;")
	text = replacetext(text, "�", "&#x420;")
	text = replacetext(text, "�", "&#x421;")
	text = replacetext(text, "�", "&#x422;")
	text = replacetext(text, "�", "&#x423;")
	text = replacetext(text, "�", "&#x424;")
	text = replacetext(text, "�", "&#x425;")
	text = replacetext(text, "�", "&#x426;")
	text = replacetext(text, "�", "&#x427;")
	text = replacetext(text, "�", "&#x428;")
	text = replacetext(text, "�", "&#x429;")
	text = replacetext(text, "�", "&#x42A;")
	text = replacetext(text, "�", "&#x42B;")
	text = replacetext(text, "�", "&#x42C;")
	text = replacetext(text, "�", "&#x42D;")
	text = replacetext(text, "�", "&#x42E;")
	text = replacetext(text, "�", "&#x42F;")
	return text