# Use the official Tomcat 7 image as the base image
FROM tomcat:7


# Copy the WAR file of target Tomcat application to the webapps directory in Tomcat
COPY tomcat-app.war /usr/local/tomcat/webapps/ROOT.war

# Set environment variables
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

# Remove the default Tomcat applications to reduce attack surface
RUN rm -rf $CATALINA_HOME/webapps/docs \
           $CATALINA_HOME/webapps/examples \
           $CATALINA_HOME/webapps/host-manager \
           $CATALINA_HOME/webapps/manager

# Ensure Tomcat runs with a non-privileged user for security reasons
RUN groupadd -r tomcat && useradd -r -g tomcat tomcat
RUN chown -R tomcat:tomcat $CATALINA_HOME

# Expose port 8080 to allow external access to the Tomcat application
EXPOSE 8080

# Switch to the non-privileged user when running the container
USER tomcat

# Run Tomcat
CMD ["catalina.sh", "run"]
