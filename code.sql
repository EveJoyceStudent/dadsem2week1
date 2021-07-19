-- CREATE DATABASE WEEK1

-- USE WEEK1

-- CREATE PROCEDURE MULTIPLY @NUM1 int, @NUM2 int AS
-- BEGIN
--     SELECT CONCAT('The Product of ', @NUM1, ' and ', @NUM2, ' is ', @NUM1*@NUM2);
-- END;

BEGIN
EXEC MULTIPLY @NUM1 = 2, @NUM2 = 3;
END;

GO;
-- CREATE FUNCTION ADDFUNCTION (@NUM1 int, @NUM2 int) RETURNS INT AS
-- BEGIN
--     RETURN @NUM1+@NUM2;
-- END;
GO;

BEGIN
    SELECT CONCAT('The Sum of 2 and 3 is ', dbo.ADDFUNCTION(2,3));
END;

IF OBJECT_ID('ACCOUNT') IS NOT NULL
DROP TABLE    ACCOUNT;

CREATE TABLE ACCOUNT(
    AcctNo INT,
    FName NVARCHAR(50),
    LName NVARCHAR(50),
    CreditLimit INT,
    Balance INT,
    PRIMARY KEY (AcctNo)
)

IF OBJECT_ID('LOG') IS NOT NULL
DROP TABLE    LOG;

CREATE TABLE LOG(
    OrigAcct INT,
    LogDateTime DATETIME,
    RecAcct INT,
    Amount INT,
    PRIMARY KEY (OrigAcct, LogDateTime),
    FOREIGN Key (OrigAcct) REFERENCES ACCOUNT,
    FOREIGN Key (RecAcct) REFERENCES ACCOUNT
)

GO;

CREATE PROCEDURE TRANSFER @FromAccount int, @ToAccount int, @Amount INT AS
BEGIN
    UPDATE ACCOUNT
    SET Balance = Balance-@Amount
    WHERE AcctNo = @FromAccount;
    UPDATE ACCOUNT
    SET Balance = Balance+@Amount
    WHERE AcctNo = @ToAccount;

    INSERT INTO LOG(OrigAcct, LogDateTime, RecAcct, Amount)
    VALUES (@FromAccount, GETDATE(), @ToAccount, @Amount);
END;

INSERT INTO ACCOUNT(AcctNo, FName, LName, CreditLimit, Balance)
VALUES
(1,'Rich','Man',10000,100000),
(2,'Poor','Manuel',1000,10);

SELECT * FROM ACCOUNT;
SELECT * FROM LOG;


BEGIN
    EXEC TRANSFER @FromAccount=1, @ToAccount=2, @Amount=1000;
END;

SELECT * FROM ACCOUNT;
SELECT * FROM LOG;
