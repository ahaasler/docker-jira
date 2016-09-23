FROM ahaasler/jira-base:alpine-8u102b14-server-jre
MAINTAINER Adrian Haasler García <dev@adrianhaasler.com>

# Configuration
ENV JIRA_VERSION 6.4.13

# Download and install jira in /opt with proper permissions and clean unnecessary files
RUN curl -Lks http://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-$JIRA_VERSION.tar.gz -o /tmp/jira.tar.gz \
	&& mkdir -p /opt/jira \
	&& tar -zxf /tmp/jira.tar.gz --strip=1 -C /opt/jira \
	&& chown -R root:root /opt/jira \
	&& chown -R 547:root /opt/jira/logs /opt/jira/temp /opt/jira/work \
	&& rm /tmp/jira.tar.gz

# Add jira customizer and launcher
COPY launch.sh /launch

# Make jira customizer and launcher executable
RUN chmod +x /launch

# Expose ports
EXPOSE 8080

# Workdir
WORKDIR /opt/jira

# Launch jira
ENTRYPOINT ["/launch"]
