/datum/controller/gameticker
	var/update_waiting = FALSE			//build updating?
	var/updater_ckey = ""				//who updating build?

/client/proc/update_server()
	set category = "Server"
	set name = "Update Server"

	if (!usr.client.holder)
		return

	if(currentbuild.folder == currentbuild.update)
		to_chat(usr, "������. ����������� ���� �� ��������")
		return

	if(ticker.buildchangechecked)
		to_chat(usr, "�� �� ������ �������� ������ ��� ��� ������������� ������� ����� �����.")
		return

	var/confirm = alert("End the round and update server?", "End Round", "Yes", "Cancel")
	if(confirm == "Cancel")
		return

	if(confirm == "Yes")
		message_admins("[key_name_admin(usr)] ��������(�) ���������� �������.")
		log_game("[key_name_admin(usr)] ��������(�) ���������� �������.")
		force_update_server()

/client/proc/update_server_round_end()
	set category = "Server"
	set name = "Update Server at Round End"

	if(!usr.client.holder)
		return

	if(currentbuild.folder == currentbuild.update)
		to_chat(usr, "������. ����������� ���� �� ��������.")
		return

	if(ticker.buildchangechecked)
		to_chat(usr, "�� �� ������ �������� ������ ��� ��� ������������� ������� ����� �����.")
		return

	var/confirm = alert("������������ ���������� � ����� ������?", "End Round", "Yes", "No", "Cancel Update")
	if(confirm == "Yes")
		message_admins("[key_name_admin(usr)] �����������(�) ���������� ������� � ����� �������� ������.")
		log_game("[key_name_admin(usr)] �����������(�) ���������� ������� � ����� �������� ������.")
		to_chat(world, "<span class='pm'><span class='howto'><b>~~ [usr.client.holder.rights & R_ADMIN ? "�������������" : "���������"] [ticker.updater_ckey] �����������(�) ���������� ������� � ����� �������� ������ ~~</b></span></span>\n")
		ticker.update_waiting = TRUE
		ticker.updater_ckey = usr.key
		return

	else if(confirm == "Cancel Update")
		message_admins("[key_name_admin(usr)] �������(�) ���������� ������� � ����� �������� ������.")
		log_game("[key_name_admin(usr)] �������(�) ���������� ������� � ����� �������� ������.")
		ticker.update_waiting = FALSE
		ticker.updater_ckey = ""
		return
	else
		return


/proc/force_update_server()
	if(currentbuild.folder == currentbuild.update)
		to_chat(world, "������ ���������&#255;. ������������� �� ��������� ����� �� ��������.")
		return

	if(ticker.buildchangechecked)
		to_chat(usr, "�� �� ������ �������� ������ ��� ��� ������������� ������� ����� �����.")
		return

	to_chat(world, "<span class='adminooc'><FONT size=5>��������! ������ ����������� ����� 10 ������! ������ �� ����� �������� ��������� �����!</FONT><br>���������� � ����� ������ ������������ [usr.client.holder.rights & R_ADMIN ? "���������������" : "�����������"] [usr.key] [ticker.updater_ckey]</span>.")
	sound_to(world, sound('sound/effects/alarm.ogg', repeat = 0, wait = 0, volume = 100, channel = 1))
	sleep(100)
	shell("sudo sh ../update.sh [currentbuild.dmb_file] [currentbuild.folder] [world.port] [currentbuild.update]")

