function Comma2Dot(FileName,x,y,z)
file  = memmapfile(FileName, 'writable', true);
comma = uint8(',');
point = uint8('.');
file.Data(transpose(file.Data == comma)) = point;
end