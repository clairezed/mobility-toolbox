class AdminMailer < ApplicationMailer

  helper :comment

  def comment_created(comment)
    @comment = comment
    subject = "Nouveau commentaire pour #{@comment.tool.title}"
    mail(to: DEFAULT_RECIPIENT, subject: subject)
  end

  def tool_submitted(tool)
    @tool = tool
    subject = "Nouvel outil, #{@tool.title}, proposé"
    mail(to: DEFAULT_RECIPIENT, subject: subject)
  end

end
