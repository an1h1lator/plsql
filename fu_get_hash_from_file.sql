CREATE OR REPLACE FUNCTION fu_get_hash_from_file (pDirectory VARCHAR2, pFile VARCHAR2) RETURN VARCHAR2 AS

dest_loc BLOB;
src_loc BFILE := BFILENAME(pDirectory, pFile);
l_encrypted_raw RAW(32635);

BEGIN

DBMS_LOB.createtemporary(dest_loc, TRUE);
DBMS_LOB.open(src_loc, DBMS_LOB.LOB_READONLY);
DBMS_LOB.open(dest_loc, DBMS_LOB.LOB_READWRITE);
DBMS_LOB.loadfromfile ( dest_lob => dest_loc,
                        src_lob  => src_loc,
                        amount   => DBMS_LOB.getLength(src_loc));

l_encrypted_raw := dbms_crypto.hash(dest_loc, DBMS_CRYPTO.hash_sh1);


DBMS_LOB.close(dest_loc);
DBMS_LOB.close(src_loc);

RETURN CAST(l_encrypted_raw AS VARCHAR2);

END fu_get_hash_from_file;
