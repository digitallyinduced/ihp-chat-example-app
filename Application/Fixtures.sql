

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE public.channels DISABLE TRIGGER ALL;

INSERT INTO public.channels (id, name, created_at) VALUES ('8916e452-bbc8-41dc-82dc-b1dcb6853e75', 'main', '2022-08-29 15:08:55.731472-04');


ALTER TABLE public.channels ENABLE TRIGGER ALL;


ALTER TABLE public.users DISABLE TRIGGER ALL;

INSERT INTO public.users (id, email, password_hash, locked_at, failed_login_attempts) VALUES ('a9795c42-860f-4e7f-812a-2f0926ae7743', 'demo@digitallyinduced.com', 'sha256|17|2RyET+ieIabj4FlJy+MnTA==|+V6W6ALP+CSIQYeZluEpzTm6SsQtOz4PvqYramGiav0=', NULL, 0);


ALTER TABLE public.users ENABLE TRIGGER ALL;


ALTER TABLE public.messages DISABLE TRIGGER ALL;

INSERT INTO public.messages (id, user_id, channel_id, body, created_at) VALUES ('1825a59f-e043-492a-a65f-8ce7c33897d7', 'a9795c42-860f-4e7f-812a-2f0926ae7743', '8916e452-bbc8-41dc-82dc-b1dcb6853e75', 'Test', '2022-08-29 15:09:12.540436-04');


ALTER TABLE public.messages ENABLE TRIGGER ALL;


