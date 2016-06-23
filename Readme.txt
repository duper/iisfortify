.___.___  ____________________            __  .__  _____       
|   |   |/   _____/\_   _____/___________/  |_|__|/ ____\__.__.
|   |   |\_____  \  |    __)/  _ \_  __ \   __\  \   __<   |  |
|   |   |/        \ |     \(  <_> )  | \/|  | |  ||  |  \___  |
|___|___/_______  / \___  / \____/|__|   |__| |__||__|  / ____|
                \/      \/                              \/     
				
      Windows Server 2003/2008/2012 R2 IIS Hardening Script
	              by Chris Campbell
						 
Version History
"""""""""""""""
v1.0.1 - Initial release.
v1.0.2 - Converted project to 'IISFortify'. Added HTTP Response header configuration.
v1.0.3 - Added support for Server 2003 x86/x64.
v1.0.4 - HTTP response headers now configured on Server 2003 via adsutil.vbs.
v1.0.5 - Disabled SSL v3.0 to address Poodle vulnerability: https://www.us-cert.gov/ncas/alerts/TA14-290A
v1.1.0 - Added new GCM cipher suites enabled in Server 2012 R2 by MS14-066, and SHA256/384/512 support in 2008+.
v1.1.1 - Updated 'cache-control' header configuration.
v1.1.2 - Fixed up unescaped semi-colons in HTTP response headers.
v1.2.0 - Update for Windows 10/Server 2016. Cipher suite list further restricted for HTTPv2.


Complimentary Documentation
"""""""""""""""""""""""""""
A list of changes that can be handed to clients:
- Fact Sheet.pdf
- https://docs.google.com/a/jadeworld.com/document/d/1096S36uvkqCdFL1xAcBpeuBFF-2VBDw7ctLAo_7EXLw/edit

			
Directions
""""""""""
Copy the required file(s) out to the server.
Apply the changes:
- SSL Only: Run the .reg script and OK the changes.
- SSL + Headers: Run fortify.cmd.
- Server 2003: Install the following patches:
-- https://support.microsoft.com/en-us/kb/948963
-- https://support.microsoft.com/en-us/kb/968730

Reboot the server.
If requested, test the site(s).


Testing
"""""""
To validate HTTP Response headers use a browser plugin such as Tamper Data (for Firefox) or Live HTTP Headers (for Firefox and Chrome).

Several options are presented to validate the SSL configuration:
- Use https://www.ssllabs.com/ssltest. The script should allow the server to pass with an A+ mark.

- Use OpenSSL:
-- openssl s_sclient -host <host name> -port <https port>
-- A strong configuration would appear as follows:

New, TLSv1/SSLv3, Cipher is ECDHE-ECDSA-AES256-GCM-SHA384
Server public key is 521 bit
Secure Renegotiation IS supported
Compression: NONE
Expansion: NONE

- Using Chrome, click on the padlock icon and then select "connection details". The cipher and key exchange mechanism utilised by the browser will be noted.
- Use the Calomel plugin for Firefox: https://calomel.org/firefox_ssl_validation.html


Conditions
""""""""""
The implemented standard will not be supported by OS's below XP SP3 and Windows 2000 SP3. Anything newer will use at least TLS1.0.


Linux Policy
""""""""""""
References:
- https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
- https://community.qualys.com/blogs/securitylabs/2013/08/05/configuring-apache-nginx-and-openssl-for-forward-secrecy

Apache (below 2.4):
SSLProtocol ALL -SSLv2 -SSLv3
SSLHonorCipherOrder On
SSLCipherSuite ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS

Apache (new builds):
SSLProtocol ALL -SSLv2 -SSLv3
SSLCompression off
SSLHonorCipherOrder on
SSLCipherSuite ECDHE+AESGCM:ECDH+AESGCM:EDH+AESGCM:ECDHE+AES256:ECDH+AES256:EDH+AES256:ECDHE+AES128:ECDH+AES128:EDH+AES128:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS

Nginx:
ssl_prefer_server_ciphers On;
ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
ssl_ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS;