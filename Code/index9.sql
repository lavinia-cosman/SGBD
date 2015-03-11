-- se creeaza prima data un nou filegroup
ALTER DATABASE AdventureWorks
ADD FILEGROUP FG2

-- se adauga un nou fișier la baza de date pe filegroup-ul nou creat
ALTER DATABASE AdventureWorks
ADD FILE
( NAME = AW2,
FILENAME = 'c:\Apress\aw2.ndf',
SIZE = 1MB
)
TO FILEGROUP FG2


-- se creeaza indexul ce va si stocat pe noul filegroup
CREATE INDEX NI_ProductPhoto_ThumnailPhotoFileName ON
Production.ProductPhoto (ThumbnailPhotoFileName)
ON [FG2]


