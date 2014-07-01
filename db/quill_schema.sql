--
-- Name: categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE categories (
    id serial primary key,
    title text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: grammar_rules; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE grammar_rules (
    id serial primary key,
    identifier character varying(255),
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    practice_lesson text,
    author_id integer
);


--
-- Name: grammar_tests; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE grammar_tests (
    id serial primary key,
    text text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: rule_examples; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rule_examples (
    id serial primary key,
    title text,
    correct boolean DEFAULT false NOT NULL,
    text text,
    rule_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: rule_question_inputs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rule_question_inputs (
    id serial primary key,
    step character varying(255),
    rule_question_id integer,
    score_id integer,
    first_input text,
    second_input text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    activity_session_id character varying(255)
);

--
-- Name: rule_questions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rule_questions (
    id serial primary key,
    body text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    rule_id integer,
    prompt text,
    instructions text,
    hint text
);

--
-- Name: rules; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rules (
    id serial primary key,
    name text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    category_id integer,
    workbook_id integer DEFAULT 1,
    description text,
    classification character varying(255),
    uid character varying(255),
    flags character varying(255)[] DEFAULT '{}'::character varying[] NOT NULL
);

--
-- Name: rules_misseds; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rules_misseds (
    id serial primary key,
    rule_id integer,
    user_id integer,
    assessment_id integer,
    time_take timestamp without time zone,
    missed boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
