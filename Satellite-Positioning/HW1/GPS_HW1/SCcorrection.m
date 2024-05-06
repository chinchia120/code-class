function [La] = SCcorrection(La,epochstart,epochend)
%f_index : 頻率數目  1:L1  2:L2

% zvec = 1.023;
for i = epochstart:epochend
        n= La.NC(i);              %length(L.PHASE(:,j,i))
%         usrplh = xyz2llh(stnxyz(j,:));
        for k =1:n%每時刻下觀測量數目
            %===衛星質心到衛星天線改正===%
            svn = La.IDC(i,k+2);
%             if ((svn == 11) ||(svn == 12) || (svn == 13) || (svn == 14) ||(svn == 16) || (svn == 18) ||(svn == 19) ||...
%                     (svn == 20) ||(svn == 21) ||(svn == 22) || (svn == 23) ||(svn == 28) || (svn == 31) )
%                 zvec = 0;
           %====2009===%%
            if ((svn == 1) || (svn == 2) || (svn == 5) || (svn == 6) || (svn == 7) ||(svn == 11) ||(svn == 12) ||...
                (svn == 13) || (svn == 14) || (svn == 15) || (svn == 16) || (svn == 17) || (svn == 18) ||(svn == 19) ||...
                    (svn == 20) ||(svn == 21) ||(svn == 22) || (svn == 23) ||(svn == 28) || (svn == 29) || (svn == 31) || (svn == 32) )
                zvec = 0;
           %============%%     
            else
                zvec = 1.023;
            end
            cmdist=norm(La.SVMAT(k,:,i));
            for kk = 1:3
                ratio = (cmdist-zvec)/cmdist;
                La.SVMAT(k,kk,i) = La.SVMAT(k,kk,i)*ratio;
            end
            %==========================%
            %===衛星質心到衛星天線改正===%
            svn = La.IDC(i,k+2) ;
%                  if ((svn == 11) ||(svn == 12) || (svn == 13) || (svn == 14) ||(svn == 16) || (svn == 18) ||(svn == 19) ||...
%                     (svn == 20) ||(svn == 21) ||(svn == 22) || (svn == 23) ||(svn == 28) || (svn == 31) )
%                 zvec = 0;
           %====2009===%%
            if ((svn == 1) || (svn == 2) || (svn == 5) || (svn == 6) || (svn == 7) ||(svn == 11) ||(svn == 12) ||...
                (svn == 13) || (svn == 14) || (svn == 15) || (svn == 16) || (svn == 17) || (svn == 18) ||(svn == 19) ||...
                    (svn == 20) ||(svn == 21) ||(svn == 22) || (svn == 23) ||(svn == 28) || (svn == 29) || (svn == 31) || (svn == 32) )
                zvec = 0;
           %============%%     
            else
                zvec = 1.023;
            end
            cmdist=norm(La.SVMAT2(k,:,i));
            for kk = 1:3
                ratio = (cmdist-zvec)/cmdist;
                La.SVMAT2(k,kk,i) = La.SVMAT2(k,kk,i)*ratio;
            end
            %==========================%
        end
clear n
end