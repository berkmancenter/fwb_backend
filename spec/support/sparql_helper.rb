%x(pkill 4s-backend)
%x(pkill 4s-httpd)
%x(4s-backend-setup test)
%x(4s-backend test)
%x(4s-httpd -p 8890 test)
