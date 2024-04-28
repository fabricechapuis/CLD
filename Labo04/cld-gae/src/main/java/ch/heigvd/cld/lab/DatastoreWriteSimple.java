package ch.heigvd.cld.lab;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Enumeration;

@WebServlet(name = "DatastoreWrite", value = "/datastorewrite")
public class DatastoreWriteSimple extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("text/plain");
        PrintWriter pw = resp.getWriter();
        pw.println("Writing entity to datastore.");

        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        Enumeration<String> parameterNames = req.getParameterNames();
        String kind = req.getParameter("_kind");
        if (kind == null){
            pw.println("Kind not specified");
        }
        else {
            String key = req.getParameter("_key");
            Entity entity;
            if (key != null) {
                entity = new Entity(kind, key);
            } else {
                entity = new Entity(kind);
            }
            while (parameterNames.hasMoreElements()) {
                String parameter = parameterNames.nextElement();
                if (!parameter.equals("_kind") && !parameter.equals("_key")) {
                    entity.setProperty(parameter, req.getParameter(parameter));
                    datastore.put(entity);
                }
            }
        }
    }
}
