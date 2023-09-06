
### VERSION 1
# class MyController
#     def execute(req, res)
#         if req.path == "/cats"
#             res.write("Hello cats!")
#         elsif req.path == "/dogs"
#             res.status = 302
#             res.location = "/cats"
#         elsif req.path == "/html"
#             res.write("<h1>HTML is just a string after all</h1>")
#         else
#             res.write("hello world!")
#         end
#     end
# end

class MyController
    def initialize(req, res)
        @req = req
        @res = res
    end

    def redirect_to(url)
        @res.status = 302
        @res.location = url
        nil
    end

    def render(content, content_type="text/html")
        @res.write(content)
        @res['Content-Type'] = content_type
        nil
    end

     def execute(req, res)
        if req.path == "/cats"
            render "hello cats!"
        elsif req.path == "/dogs"
            redirect_to "/cats"
        elsif req.path == "/html"
            render "<h1>HTML is just a string after all</h1>"
        else
            render "hello world!"
        end
    end
end

app = Proc.new do |env|
    req = Rack::Request.new(env)
    res = Rack::Response.new
    MyController.new.execute(req, res)
    res.finish
end

Rack::Server.start({
    app: app,
    Port: 3000
})