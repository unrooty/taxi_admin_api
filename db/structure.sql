--
-- PostgreSQL database dump
--

-- Dumped from database version 10.3 (Ubuntu 10.3-1.pgdg16.04+1)
-- Dumped by pg_dump version 10.3 (Ubuntu 10.3-1.pgdg16.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: check_if_tax_not_default(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.check_if_tax_not_default() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

  IF (SELECT by_default FROM taxes WHERE id = OLD.id) = true THEN

    RAISE EXCEPTION 'Can not delete default tax';

  END IF;

  IF ((SELECT COUNT(*) FROM orders WHERE tax_id = OLD.id) >= 1) THEN

    RAISE EXCEPTION 'Tax can not be deleted. One or more orders are associated to this tax.';

  END IF;

  RETURN OLD;

END
$$;


--
-- Name: check_tax(boolean, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.check_tax(val boolean DEFAULT true, result text DEFAULT 'false'::text) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN

  IF ((SELECT COUNT(*) FROM taxes WHERE by_default = val) = 1) AND (val = true) THEN

    result := 'false';

  ELSE

    result := 'true';
  END IF;

  RETURN result;
END
$$;


--
-- Name: check_tax(integer, boolean, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.check_tax(old_id integer, val boolean DEFAULT true, result text DEFAULT 'false'::text) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN

  IF ((SELECT COUNT(*) FROM taxes WHERE ((by_default = val) AND (id <> old_id))) = 1 AND (val = true)) THEN

    result := 'false';

  ELSE

    result := 'true';
  END IF;

  RETURN result;
END
$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: affiliates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.affiliates (
    id integer NOT NULL,
    name character varying NOT NULL,
    address character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: affiliates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.affiliates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: affiliates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.affiliates_id_seq OWNED BY public.affiliates.id;


--
-- Name: cars; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cars (
    id integer NOT NULL,
    brand character varying NOT NULL,
    car_model character varying NOT NULL,
    reg_number character varying NOT NULL,
    color character varying NOT NULL,
    style character varying NOT NULL,
    affiliate_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer,
    car_status text DEFAULT 'Free'::text NOT NULL,
    CONSTRAINT check_brand_length CHECK ((char_length((brand)::text) <= 25)),
    CONSTRAINT check_car_model_length CHECK ((char_length((car_model)::text) <= 25)),
    CONSTRAINT check_car_status CHECK (((car_status = 'Free'::text) OR (car_status = 'Ordered'::text))),
    CONSTRAINT check_color_length CHECK ((char_length((color)::text) <= 25)),
    CONSTRAINT check_style_length CHECK ((char_length((style)::text) <= 25)),
    CONSTRAINT reg_number_regex CHECK (((reg_number)::text ~ '[A-Z]{2}-[0-9]{4}-[1-7]'::text))
);


--
-- Name: cars_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cars_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cars_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cars_id_seq OWNED BY public.cars.id;


--
-- Name: feedbacks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.feedbacks (
    id integer NOT NULL,
    name character varying NOT NULL,
    email character varying NOT NULL,
    message character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    CONSTRAINT check_message_length CHECK ((char_length((message)::text) >= 10)),
    CONSTRAINT email_regex CHECK (((email)::text ~ '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'::text))
);


--
-- Name: feedbacks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.feedbacks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feedbacks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.feedbacks_id_seq OWNED BY public.feedbacks.id;


--
-- Name: invoices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invoices (
    id integer NOT NULL,
    distance numeric DEFAULT 0 NOT NULL,
    total_price numeric DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    order_id integer NOT NULL,
    payed_amount numeric DEFAULT 0.0 NOT NULL,
    invoice_status text DEFAULT 'Unpaid'::text NOT NULL,
    indebtedness numeric DEFAULT 0.0 NOT NULL,
    CONSTRAINT check_distance_value CHECK ((distance >= (0)::numeric)),
    CONSTRAINT check_indebtedness_value CHECK ((indebtedness >= (0)::numeric)),
    CONSTRAINT check_invoice_status CHECK (((invoice_status = 'Paid'::text) OR (invoice_status = 'Unpaid'::text) OR (invoice_status = 'Partially paid'::text))),
    CONSTRAINT check_payed_amount_value CHECK ((payed_amount >= (0)::numeric)),
    CONSTRAINT check_total_price_value CHECK ((total_price >= (0)::numeric))
);


--
-- Name: invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.invoices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.invoices_id_seq OWNED BY public.invoices.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    car_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    end_point character varying NOT NULL,
    client_name character varying NOT NULL,
    client_phone character varying NOT NULL,
    user_id integer,
    tax_id integer NOT NULL,
    start_point character varying NOT NULL,
    order_status text DEFAULT 'New'::text NOT NULL,
    CONSTRAINT check_client_phone_length CHECK ((char_length((client_phone)::text) = 9)),
    CONSTRAINT check_order_status CHECK (((order_status = 'New'::text) OR (order_status = 'In progress'::text) OR (order_status = 'Completed'::text)))
);


--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: refresh_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.refresh_tokens (
    id integer NOT NULL,
    token text NOT NULL,
    aud text,
    expires_in timestamp without time zone NOT NULL,
    user_id integer NOT NULL,
    device_id text DEFAULT ''::text NOT NULL
);


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.refresh_tokens_id_seq OWNED BY public.refresh_tokens.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    filename text NOT NULL
);


--
-- Name: taxes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.taxes (
    id integer NOT NULL,
    cost_per_km numeric NOT NULL,
    basic_cost numeric NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    by_default boolean DEFAULT false NOT NULL,
    CONSTRAINT check_basic_cost_value CHECK ((basic_cost >= (0)::numeric)),
    CONSTRAINT check_cast_per_km_value CHECK ((cost_per_km >= (0)::numeric)),
    CONSTRAINT check_default_tax_not_exist CHECK ((public.check_tax(id, by_default) = 'true'::text))
);


--
-- Name: taxes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.taxes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taxes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.taxes_id_seq OWNED BY public.taxes.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    phone character varying NOT NULL,
    affiliate_id integer,
    role text DEFAULT 'Client'::text NOT NULL,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    language text DEFAULT 'Russian'::text NOT NULL,
    address text DEFAULT ''::text,
    city text DEFAULT ''::text,
    active boolean DEFAULT true NOT NULL,
    activation_token text,
    CONSTRAINT check_phone_length CHECK ((char_length((phone)::text) = 9)),
    CONSTRAINT check_roles CHECK (((role = 'Admin'::text) OR (role = 'Client'::text) OR (role = 'Dispatcher'::text) OR (role = 'Driver'::text) OR (role = 'Manager'::text) OR (role = 'Accountant'::text)))
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: affiliates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.affiliates ALTER COLUMN id SET DEFAULT nextval('public.affiliates_id_seq'::regclass);


--
-- Name: cars id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cars ALTER COLUMN id SET DEFAULT nextval('public.cars_id_seq'::regclass);


--
-- Name: feedbacks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedbacks ALTER COLUMN id SET DEFAULT nextval('public.feedbacks_id_seq'::regclass);


--
-- Name: invoices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices ALTER COLUMN id SET DEFAULT nextval('public.invoices_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('public.refresh_tokens_id_seq'::regclass);


--
-- Name: taxes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taxes ALTER COLUMN id SET DEFAULT nextval('public.taxes_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: affiliates affiliates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.affiliates
    ADD CONSTRAINT affiliates_pkey PRIMARY KEY (id);


--
-- Name: cars cars_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cars
    ADD CONSTRAINT cars_pkey PRIMARY KEY (id);


--
-- Name: feedbacks feedbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT feedbacks_pkey PRIMARY KEY (id);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_device_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_device_id_key UNIQUE (device_id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (filename);


--
-- Name: taxes taxes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taxes
    ADD CONSTRAINT taxes_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: affiliates_lower__name___index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX affiliates_lower__name___index ON public.affiliates USING btree (lower((name)::text));


--
-- Name: cars_reg_number_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX cars_reg_number_index ON public.cars USING btree (reg_number);


--
-- Name: index_cars_on_affiliate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cars_on_affiliate_id ON public.cars USING btree (affiliate_id);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON public.users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: invoices_order_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX invoices_order_id_index ON public.invoices USING btree (order_id);


--
-- Name: refresh_tokens_token_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX refresh_tokens_token_index ON public.refresh_tokens USING btree (token);


--
-- Name: taxes_lower__name___index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX taxes_lower__name___index ON public.taxes USING btree (lower((name)::text));


--
-- Name: taxes check_if_tax_default; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER check_if_tax_default BEFORE DELETE ON public.taxes FOR EACH ROW EXECUTE PROCEDURE public.check_if_tax_not_default();


--
-- Name: orders fk_rails_880a1f8e56; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fk_rails_880a1f8e56 FOREIGN KEY (car_id) REFERENCES public.cars(id);


--
-- Name: cars fk_rails_9524a0365f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cars
    ADD CONSTRAINT fk_rails_9524a0365f FOREIGN KEY (affiliate_id) REFERENCES public.affiliates(id);


--
-- Name: orders fk_rails_bfc01f48d8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fk_rails_bfc01f48d8 FOREIGN KEY (tax_id) REFERENCES public.taxes(id);


--
-- Name: refresh_tokens refresh_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;
INSERT INTO "schema_migrations" ("filename") VALUES ('20180320080756_null_schema_migration.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180320093744_correct_taxes_deletion.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180320104922_orders_modification.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180320150556_configure_user_roles.rb');