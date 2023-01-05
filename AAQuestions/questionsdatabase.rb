require "singleton"
require 'sqlite3'

class QuestionsDatabase < SQLite3::Database
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end

class User
    attr_accessor :id, :fname, :lname
    def initialize(options)
        @id = options["id"]
        @fname = options["fname"]
        @lname = options["lname"]
    end

    def self.find_by_id(id)
        user = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
              *
            FROM
              users
            WHERE
              id = ?
            SQL
            return nil unless user.length > 0

        User.new(user.first)
    end

    def self.find_by_name(fname, lname)
        user = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
            SELECT
              *
            FROM
            users
            WHERE
            fname = ?
            AND
            lname = ?
            SQL
            return nil unless user.length > 0
        User.new(user.first)
    end

    def authored_questions
        Question.find_by_author_id(id)
    end

    def authored_replies
        Reply.find_by_user_id(id)
    end
end
#---------------------------------------------------------------#
class Question
    attr_accessor :id, :title, :body, :author_id
    def initialize(options)
        @id = options["id"]
        @title = options["title"]
        @body = options["body"]
        @author_id = options["author_id"]
    end

    def self.find_by_id(id)
        question = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
              *
            FROM
              questions
            WHERE
              id = ?
            SQL
            return nil unless question.length > 0

        Question.new(question.first)
    end

    def self.find_by_author_id(author_id)
        question = QuestionsDatabase.instance.execute(<<-SQL, author_id)
            SELECT
              *
            FROM
              questions
            WHERE
              author_id = ?
            SQL
            return nil unless question.length > 0

        Question.new(question.first)
    end

    def replies
        Reply.find_by_question_id(id)
    end

    def author
        Reply.find_by_author_id(author_id)
    end

end
#---------------------------------------------------------------#
class Question_follow
    attr_accessor :id, :user_id, :question_id
    def initialize(options)
        @id = options["id"]
        @user_id = options["user_id"]
        @question_id = options["question_id"]
    end

    def self.find_by_id(id)
        question_follow = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
          *
        FROM
          question_follows
        WHERE
          id = ?
        SQL
        return nil unless question_follow.length > 0

    Question_follow.new(question_follow.first)
    end

end
#---------------------------------------------------------------#
class Question_like
    attr_accessor :id, :user_id, :question_id
    def initialize(options)
        @id = options["id"]
        @user_id = options["user_id"]
        @question_id = options["question_id"]
    end

    def self.find_by_id(id)
        question_like = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
          *
        FROM
          question_likes
        WHERE
          id = ?
        SQL
        return nil unless question_like > 0

    Question_like.new(question_like.first)
    end
end
#---------------------------------------------------------------#
class Question_tag
    attr_accessor :id, :user_id, :tag_id
    def initialize(options)
        @id = options["id"]
        @user_id = options["user_id"]
        @tag_id = options["tag_id"]
    end

    def self.find_by_id(id)
        question_tag = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
          *
        FROM
          question_tags
        WHERE
          id = ?
        SQL
        return nil unless question_tag.length > 0

    Question_tag.new(question_tag.first)
    end
end

#---------------------------------------------------------------#
class Reply
    attr_accessor :id, :question_id, :parent_reply_id, :author_id, :body
    def initialize(options)
        @id = options[id]
        @question_id = options["question_id"]
        @parent_reply_id = options["parent_reply_id"]
        @author_id = options["author_id"]
        @body = options["body"]
    end

    def self.find_by_id(id)
        reply = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
          *
        FROM
          replies
        WHERE
          id = ?
        SQL
        return nil unless reply.length > 0

    Reply.new(reply.first)
    end

    def find_by_user_id(user_id)
        reply = QuestionsDatabase.instance.execute(<<-SQL, id )
            SELECT
                *
            FROM
                replies
            WHERE
                user_id = ?
        SQL
        return nil unless reply.length > 0
        Reply.new(reply.first)
    end

    def find_by_question_id(question_id)
        reply = QuestionsDatabase.instance.execute(<<-SQL, id )
            SELECT
                *
            FROM
                replies
            WHERE
                question_id = ?
        SQL
        return nil unless reply.length > 0
        Reply.new(reply.first)
    end

    def author
        User.find_by_id(author_id)
    end

    def question
        Question.find_by_id(question_id)
    end

    def parent_reply
        self.find_by_id(parent_reply_id)
    end

    def child_replies
        child = QuestionsDatabase.instance.execute(<<-SQL, id )
            SELECT
                *
            FROM
                replies
            WHERE
                parent_reply_id = ?
        SQL
        Reply.new(child.first)
    end
end
#---------------------------------------------------------------#
# class Tag
#     attr_accessor :id, :name
#     def initialize(options)
#         @id = options["id"]
#         @name = options["name"]
#     end

#     def self.find_by_id(id)
#         tag = QuestionsDatabase.instance.execute(<<-SQL, id)
#         SELECT
#           *
#         FROM
#           tags
#         WHERE
#           id = ?
#         SQL
#         return nil unless tag.length > 0

#     Tag.new(tag.first)
#     end
# end
