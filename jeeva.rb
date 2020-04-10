#
# Cookbook Name:: hgbu_simphony_SimpOraInstall
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Author:: Ashok Medikonda
#
# Copyright 2017, Oracle HGBU
#
# All rights reserved - Do Not Redistribute
#

Chef::Log.info '---'
Chef::Log.info "--- Cookbook: #{cookbook_name} / Recipe: #{recipe_name}"

install_temp_location =  "C:\\tmp"

#databag = Chef::EncryptedDataBagItem.load( 'hgbu_simphony', 'simphony_install')
databag = data_bag_item(node['hgbu_simphony_common']['data_bag'], node['hgbu_simphony_common']['data_bag_item'],IO.read("C:\\tmp\\simpsecretkey.txt"))
#databag = data_bag_item('hgbu_simphony', "simphony_install",IO.read("/commonFiles/simpsecretkey.txt"))
	is_upgrade = databag["IS_UPGRADE_SELECT_LIST"]
	simp_iso_file_location = databag["ISO_FILE_LOCATION"]
	simpupgrade_iso_file_location = databag["UPGRADE_ISO_FILE_LOCATION"]
	installDirectory = databag["INSTALL_DIRECTORY"]
	simphonyEMCUserName = databag["SIM_EMC_USERNAME"]
	simphonyEMCPassword = databag["SIM_EMC_PASSWORD"]
	serviceHostName = databag["SIMP_SERVICE_HOST_NAME"]
	dbHostName = databag["SIMPDB_HOSTNAME"]/*change we made for Distributed env -Jeeva*/
	serviceHostPort = databag["SERVICE_HOST_PORT"]
	certNameandKey = databag["CERT_NAME_and_KEY"]
	certPassword = databag["CERT_PASSWORD"]
	installMethod = databag["INSTALL_METHOD_SELECT_LIST"]
#certNameandKey = "fac679559260b290f9db57680fe2ec1a317fa942"


#---------------- SPECIFIC FOR ORACLE RESPONSE FILE ----------------------------
	ora_serviceName = databag["ORA_SERVICE_NAME"]
	ora_transDBusername = databag["TRANSACTION_DB_USERNAME"]
	ora_transDBpassword = databag["TRANSACTION_DB_PASSWORD"]
	ora_reportingServerName = databag["ORA_REPORTING_SERVER_NAME"]
	ora_reportingServiceName = databag["ORA_REPORTING_SERVICE_NAME"]
	ora_reportingMMSQLpassword = databag["ORA_REPORTING_MMSQL_PASSWORD"]
	ora_reportingCEDBpassword = databag["ORA_REPORTING_CEDB_PASSWORD"]
	ora_secDBusername = databag["SECUTIRY_DB_USERNAME"]
	ora_secDBpassword = databag["SECURITY_DB_PASSWORD"]
	ora_adminDBusername = databag["ORA_DB_ADMIN_USERNAME"]
	ora_adminDBpassword = databag["ORA_DB_ADMIN_PASSWORD"]
	ora_reportingAdminDBusername = databag["ORA_REPORTING_DB_ADMIN_USERNAME"]
	ora_reportingAdminDBpassword = databag["ORA_REPORTING_DB_ADMIN_PASSWORD"]


#---------------- SPECIFIC FOR MSSQL RESPONSE FILE --------------------------------

	sql_instance_name = databag["SIMP_SERVICE_HOST_NAME"]
	sql_transDBusername = databag["TRANSACTION_DB_USERNAME"]
	sql_transDBpassword = databag["TRANSACTION_DB_PASSWORD"]
	sql_reportingServerName = databag["SQL_REPORTING_SERVER_NAME"]
	sql_reportingMMSQLpassword = databag["SQL_REPORTING_MMSQL_PASSWORD"]
	sql_secDBusername = databag["SECUTIRY_DB_USERNAME"]
	sql_secDBpassword = databag["SECURITY_DB_PASSWORD"]
	sql_adminDBusername = databag["SQL_DB_ADMIN_USERNAME"]
	sql_adminDBpassword = databag["SQL_DB_ADMIN_PASSWORD"]
	sql_reportingAdminDBusername = databag["SQL_REPORTING_DB_ADMIN_USERNAME"]
	sql_reportingAdminDBpassword = databag["SQL_REPORTING_DB_ADMIN_PASSWORD"]
	sql_reportingCEDBpassword = databag["SQL_REPORTING_CEDB_PASSWORD"]

#----------------------Launch DB Backup Restore script------------------------------

	db_backup_restore = databag["DB_BACKUP_RESTORE"]

#-----------------------------------------------------------------------------------

Chef::Log.info 'Creating required directory structure'

directory "#{install_temp_location}" do
   	action :create
	recursive true
	not_if { ::File.exists?("#{install_temp_location}") }
end

directory "#{install_temp_location}\\simphonyrsp" do
   	action :create
	recursive true
	not_if { ::File.exists?("#{install_temp_location}\\simphonyrsp") }
end

cookbook_file "#{install_temp_location}\\DB_Backup_Restore.bat" do
	source 'DB_Backup_Restore.bat'
	action :create
end


template "#{install_temp_location}\\simphonyrsp\\SimphonyInstall_Oracle_Plain.xml" do
 source 'simphonyrsp/SimphonyInstall_Oracle_Plain.xml.erb'
 variables({
 		:installDirectory 			=> installDirectory,
 		:simphonyEMCUserName 		=> simphonyEMCUserName,
 		:simphonyEMCPassword 		=> simphonyEMCPassword,
 		:serviceHostName 			=> serviceHostName,
 		:serviceHostPort 			=> dbHostName,
 		:certNameandKey 			=> certNameandKey,
 		:certPassword				=> certPassword,
 		:serviceName 				=> ora_serviceName,
 		:transDBusername 			=> ora_transDBusername,
 		:transDBpassword 			=> ora_transDBpassword,
 		:reportingServerName 		=> ora_reportingServerName,
 		:reportingServiceName 		=> ora_reportingServiceName,
 		:reportingMMSQLpassword 	=> ora_reportingMMSQLpassword,
 		:reportingCEDBpassword		=> ora_reportingCEDBpassword,
 		:secDBusername 				=> ora_secDBusername,
 		:secDBpassword 				=> ora_secDBpassword,
 		:adminDBusername 			=> ora_adminDBusername,
 		:adminDBpassword 			=> ora_adminDBpassword,
 		:reportingAdminDBusername 	=> ora_reportingAdminDBusername,
 		:reportingAdminDBpassword 	=> ora_reportingAdminDBpassword

 	})
  
end

template "#{install_temp_location}\\simphonyrsp\\SimphonyInstall_SQL_Plain.xml" do
 source 'simphonyrsp/SimphonyInstall_SQL_Plain.xml.erb'
 variables({
 		:installDirectory 			=> installDirectory,
 		:simphonyEMCUserName 		=> simphonyEMCUserName,
 		:simphonyEMCPassword 		=> simphonyEMCPassword,
 		:serviceHostName 			=> serviceHostName,
 		:serviceHostPort 			=> serviceHostPort,
 		:certNameandKey 			=> certNameandKey,
 		:instanceName 				=> sql_instance_name,
 		:transDBusername 			=> sql_transDBusername,
 		:transDBpassword 			=> sql_transDBpassword,
 		:reportingServerName 		=> sql_reportingServerName,
 		:reportingMMSQLpassword 	=> sql_reportingMMSQLpassword,
 		:reportingCEDBpassword		=> sql_reportingCEDBpassword,
 		:secDBusername 				=> sql_secDBusername,
 		:secDBpassword 				=> sql_secDBpassword,
 		:adminDBusername 			=> sql_adminDBusername,
 		:adminDBpassword 			=> sql_adminDBpassword,
 		:reportingAdminDBusername 	=> sql_reportingAdminDBusername,
 		:reportingAdminDBpassword 	=> sql_reportingAdminDBpassword

 	})
end

template "#{install_temp_location}\\simphonyrsp\\SimphonyInstall_SQLUpgrade_Plain.xml" do
 source 'simphonyrsp/SimphonyInstall_SQLUpgrade_Plain.xml.erb'
 variables({
 		:installDirectory 			=> installDirectory,
 		:serviceHostName 			=> serviceHostName,
 		:serviceHostPort 			=> serviceHostPort,
 		:certNameandKey 			=> certNameandKey,
 		:instanceName 				=> sql_instance_name,
 		:transDBusername 			=> sql_transDBusername,
 		:transDBpassword 			=> sql_transDBpassword,
 		:reportingServerName 		=> sql_reportingServerName,
 		:reportingMMSQLpassword 	=> sql_reportingMMSQLpassword,
 		:reportingCEDBpassword		=> sql_reportingCEDBpassword,
 		:secDBusername 				=> sql_secDBusername,
 		:secDBpassword 				=> sql_secDBpassword,
 		:adminDBusername 			=> sql_adminDBusername,
 		:adminDBpassword 			=> sql_adminDBpassword,
 		:reportingAdminDBusername 	=> sql_reportingAdminDBusername,
 		:reportingAdminDBpassword 	=> sql_reportingAdminDBpassword

 	})
end
 
template "#{install_temp_location}\\simphonyrsp\\SimphonyInstall_OraUpgrade_Plain.xml" do
 source 'simphonyrsp/SimphonyInstall_OraUpgrade_Plain.xml.erb'
 variables({
 		:installDirectory 			=> installDirectory,
 		:serviceHostName 			=> dbHostName,
 		:serviceHostPort 			=> serviceHostPort,
 		:certNameandKey 			=> certNameandKey,
 		:certPassword				=> certPassword,
 		:serviceName 				=> ora_serviceName,
 		:transDBusername 			=> ora_transDBusername,
 		:transDBpassword 			=> ora_transDBpassword,
 		:reportingServerName 		=> ora_reportingServerName,
 		:reportingServiceName 		=> ora_reportingServiceName,
 		:reportingMMSQLpassword 	=> ora_reportingMMSQLpassword,
 		:reportingCEDBpassword		=> ora_reportingCEDBpassword,
 		:secDBusername 				=> ora_secDBusername,
 		:secDBpassword 				=> ora_secDBpassword,
 		:adminDBusername 			=> ora_adminDBusername,
 		:adminDBpassword 			=> ora_adminDBpassword,
 		:reportingAdminDBusername 	=> ora_reportingAdminDBusername,
 		:reportingAdminDBpassword 	=> ora_reportingAdminDBpassword

 	})

end

execute "Starting simp install" do
	command 'sleep 30'
end

# TODO Remove Hardcoded path once batch scrip issues are resolved
db_backup_restore_dir = "C:\\Users\\Pratmukh\\Desktop\\DB Backup Restore Script"

if is_upgrade == "NO"
Chef::Log.info 'Simphony Fresh Installation...'
	execute 'Simphony Install' do
  		command "cd #{simp_iso_file_location} & simph.exe -s #{install_temp_location}\\simphonyrsp\\SimphonyInstall_#{installMethod}_Plain.xml"
  		action :run
  		#only_if "#{is_upgrade}" = "NO"
	end
else

	if db_backup_restore == "YES"
		Chef::Log.info 'Launching DB_Backup_Restore.bat script to restore the dump file before upgrade'
		batch 'DB_Drop_Import' do
			cwd 	db_backup_restore_dir
			code 	"DB_Backup_Restore.bat > DB_Drop_Import.log" 
		end
	end

	Chef::Log.info 'Simphony Upgrade Installation.....'
	execute 'SimphonyUpgrade Install' do
   		command "cd #{simpupgrade_iso_file_location} & simph.exe -s #{install_temp_location}\\simphonyrsp\\SimphonyInstall_#{installMethod}_Plain.xml"
  		action :run
  		#only_if "#{is_upgrade}" = "YES" 
	end
	
	if db_backup_restore == "YES"
		Chef::Log.info 'Launching DB_Backup_Restore.bat script to Backup the dump file after Upgrade'
		batch 'DB_Export' do
			cwd 	db_backup_restore_dir
			code 	"DB_Backup_Restore.bat > DB_Export.log"
		end
	end

end
