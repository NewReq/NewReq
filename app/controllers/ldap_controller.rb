class LdapController < ApplicationController
    before_action :set_newuser, only: [:show, :create]
    before_action :set_newuserldap, only: [:show, :build]
    before_action :load_attributes, only: [:create]
    
    
    def index
      @newuserldap = Newuserldap.all
    end


    def show
    end


    def create
      if Newuserldap.where(:newusers_id => @newusers_id).present?
        redirect_to action: "show", id: @newuser.id
      else
        Newuserldap.create(:cn => @cn) do |u|
          u.dn = @dn
          u.objectclass = @objectclass
          u.name = @name
          u.givenname = @givenname
          u.sn = @sn
          u.cn = @cn
          u.displayname = @displayname
          u.userPrincipalName = @userPrincipalName
          u.sAMAccountName = @sAMAccountName
          u.title = @title
          u.description = @description
          u.company = @company
          u.department = @department
          u.telephoneNumber = @telephoneNumber
          u.facsimileTelephoneNumber = @facsimileTelephoneNumber
          u.homePhone = @homePhone
          u.ipPhone = @ipPhone
          u.mobile = @mobile
          u.physicalDeliveryOfficeName = @physicalDeliveryOfficeName
          u.l = @l
          u.st = @st
          u.streetAddress = @streetAddress
          u.postalCode = @postalCode
          u.postOfficeBox = @postOfficeBox
          u.c = @c
          u.manager = @manager
          u.mail = @mail
          u.proxyAddresses = @proxyAddresses
          u.wWWHomePage = @wWWHomePage
          u.userPassword = @userPassword
          u.newusers_id = @newusers_id
        end
        redirect_to action: "show", id: @newuser.id
      end
    end
    
    
    def build
      require 'rubygems'
      require 'net/ldap'

      ldap = Net::LDAP.new :host => "52.37.141.91",
                           :port => 389,
                           :auth => {
                                    :method => :simple,
                                    :username => "cn=svc-ldap,ou=usuarios,dc=intranet,dc=local",
                                    :password => "NewReq@123"
                                    }
     

      dn = @newuserldap.dn
                attr = {
                  :cn => @newuserldap.cn,
                  :userPrincipalName => @newuserldap.userPrincipalName,
                  :sAMAccountName => @newuserldap.sAMAccountName,
                  :name => @newuserldap.name,
                  :displayname => @newuserldap.displayname,
                  :objectclass => @newuserldap.objectclass,
                  :givenname => @newuserldap.givenname,
                  :sn => @newuserldap.sn,
                  :telephoneNumber => @newuserldap.telephoneNumber,
                  :facsimileTelephoneNumber => @newuserldap.facsimileTelephoneNumber,
                  :homePhone => @newuserldap.homePhone,
                  :ipPhone => @newuserldap.ipPhone,
                  :mobile => @newuserldap.mobile,
                  :mail => @newuserldap.mail,
                  :l => @newuserldap.l,
                  :st => @newuserldap.st,
                  :title => @newuserldap.title,
                  :description => @newuserldap.description,
                  :physicaldeliveryofficename => @newuserldap.physicalDeliveryOfficeName,
                  :c => @newuserldap.c,
                  :department => @newuserldap.department,
                  :company => @newuserldap.company,
                  :streetAddress => @newuserldap.streetAddress,
                  :postalCode => @newuserldap.postalCode,
                  :postOfficeBox => @newuserldap.postOfficeBox,
                  :manager => "cn=Bruno Kinoshita,ou=usuarios,dc=intranet,dc=local",
                  :proxyAddresses => @newuserldap.proxyAddresses,
                  :wWWHomePage => @newuserldap.wWWHomePage,
                  :userPassword => @newuserldap.userPassword
                }
                
      ldap.add(:dn => dn, :attributes => attr.reject!(&:blank?))
    end





    



private

    # Loading user by ID on Newuser table
    def set_newuser
      @newuser = Newuser.find(params[:id])
    end

    # Loading user by newusers_id on Newuserldap table
    def set_newuserldap
      @newuserldap = Newuserldap.where(newusers_id: params[:id]).first
    end


    # Building attributes from LDAP
    def load_attributes
      @domain = "intranet.local"
      @pubdomain = "publicdomain.com"
      @ou = ",ou=usuarios,dc=intranet,dc=local"
      @cn = @newuser.firstname + " " + @newuser.lastname
      @userPrincipalName = @newuser.username + "@" + @domain
      @mail = @newuser.username + "@" + @pubdomain
      @dn = "cn=" + @cn + @ou
      @sAMAccountName = @newuser.username
      @name = @cn
      @displayname = @cn
      @objectclass = "User"
      @givenname = @newuser.firstname
      @sn = @newuser.lastname
      @telephoneNumber = @newuser.phone
      @facsimileTelephoneNumber = @telephoneNumber
      @homePhone = @newuser.homephone
      @ipPhone = @newuser.ipphone
      @mobile = @newuser.mobile
      @physicalDeliveryOfficeName = @newuser.Office
      @l = @newuser.City
      @st = @newuser.State
      @title = @newuser.title
      @description = @newuser.description
      @c = @newuser.Country
      @department = @newuser.department
      @company = @newuser.company_id
      @streetAddress = @newuser.address
      @postalCode = @newuser.postalcode
      @postOfficeBox = @newuser.pobox
      @manager = @newuser.grant_id
      @proxyAddresses = "SMTP:" + @mail
      @wWWHomePage = @newuser.website
      @userPassword = "Teste@123*"
      @newusers_id = @newuser.id
    end

    
end