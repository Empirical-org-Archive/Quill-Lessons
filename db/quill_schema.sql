--
-- Name: categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE categories (
    id integer NOT NULL,
    title text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;

--
-- Name: grammar_rules; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE grammar_rules (
    id integer NOT NULL,
    identifier character varying(255),
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    practice_lesson text,
    author_id integer
);


--
-- Name: grammar_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE grammar_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: grammar_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE grammar_rules_id_seq OWNED BY grammar_rules.id;


--
-- Name: grammar_tests; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE grammar_tests (
    id integer NOT NULL,
    text text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: grammar_tests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE grammar_tests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: grammar_tests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE grammar_tests_id_seq OWNED BY grammar_tests.id;


--
-- Name: rule_examples; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rule_examples (
    id integer NOT NULL,
    title text,
    correct boolean DEFAULT false NOT NULL,
    text text,
    rule_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: rule_examples_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rule_examples_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rule_examples_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rule_examples_id_seq OWNED BY rule_examples.id;


--
-- Name: rule_question_inputs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rule_question_inputs (
    id integer NOT NULL,
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
-- Name: rule_question_inputs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rule_question_inputs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rule_question_inputs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rule_question_inputs_id_seq OWNED BY rule_question_inputs.id;


--
-- Name: rule_questions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rule_questions (
    id integer NOT NULL,
    body text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    rule_id integer,
    prompt text,
    instructions text,
    hint text
);


--
-- Name: rule_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rule_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rule_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rule_questions_id_seq OWNED BY rule_questions.id;


--
-- Name: rules; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rules (
    id integer NOT NULL,
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
-- Name: rules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rules_id_seq OWNED BY rules.id;


--
-- Name: rules_misseds; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rules_misseds (
    id integer NOT NULL,
    rule_id integer,
    user_id integer,
    assessment_id integer,
    time_take timestamp without time zone,
    missed boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: rules_misseds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rules_misseds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rules_misseds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rules_misseds_id_seq OWNED BY rules_misseds.id;

--
-- Name: index_rules_on_uid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_rules_on_uid ON rules USING btree (uid);

--
-- PostgreSQL database dump complete
--

