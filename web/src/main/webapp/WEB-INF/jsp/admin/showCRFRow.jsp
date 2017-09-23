<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:setBundle basename="org.akaza.openclinica.i18n.notes" var="restext"/>
<fmt:setBundle basename="org.akaza.openclinica.i18n.words" var="resword"/>
<fmt:setBundle basename="org.akaza.openclinica.i18n.format" var="resformat"/>

<jsp:useBean scope="request" id="currRow" class="org.akaza.openclinica.web.bean.ListCRFRow" />
<c:set var="count" value="${currRow.bean.versionNumber}"/>
<c:set var="count" value="${count+1}"/>
<c:set var="dteFormat"><fmt:message key="date_format_string" bundle="${resformat}"/></c:set>

<c:choose>
  <c:when test="${currRow.bean.status.name eq 'available'}">
    <c:set var="className" value="aka_green_highlight"/>
  </c:when>
  <c:when test="${currRow.bean.status.name eq 'removed'}">
    <c:set var="className" value="aka_red_highlight"/>
  </c:when>
</c:choose>
<tr valign="top" bgcolor="#F5F5F5">
  <td rowspan="<c:out value="${count}"/>" class="table_cell_left"><c:out value="${currRow.bean.name}"/></td>
  <td rowspan="<c:out value="${count}"/>" class="table_cell"><fmt:formatDate value="${currRow.bean.updatedDate}" pattern="${dteFormat}"/>&nbsp;</td>
  <td rowspan="<c:out value="${count}"/>" class="table_cell"><c:out value="${currRow.bean.updater.name}"/>&nbsp;</td>
  <td rowspan="<c:out value="${count}"/>" class="table_cell"><c:out value="${currRow.bean.oid}"/>&nbsp;</td>
  <td class="table_cell">(<fmt:message key="original" bundle="${resword}"/>)</td>
    <%--oid space --%>
  <td class="table_cell"><fmt:formatDate value="${currRow.bean.createdDate}" pattern="${dteFormat}"/></td>
  <td class="table_cell"><c:out value="${currRow.bean.owner.name}"/></td>
  <td class="table_cell <c:out value='${className}'/>"><c:out value="${currRow.bean.status.name}"/></td>
  <td class="table_cell">&nbsp;</td>
  <td class="table_cell">
    <table border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td><a href="ViewCRF?module=<c:out value="${module}"/>&crfId=<c:out value="${currRow.bean.id}"/>"
               onMouseDown="javascript:setImage('bt_View1','images/bt_View_d.gif');"
               onMouseUp="javascript:setImage('bt_View1','images/bt_View.gif');"><span
          name="bt_View1" class="icon icon-search" border="0" alt="<fmt:message key="view" bundle="${resword}"/>" title="<fmt:message key="view" bundle="${resword}"/>" align="left" hspace="6"></a>
        </td>
        <c:choose>
          <c:when test="${currRow.bean.status.available}">
            <td><a href="InitCreateCRFVersion?module=<c:out value="${module}"/>&crfId=<c:out value="${currRow.bean.id}"/>&name=<c:out value="${currRow.bean.name}"/>"
                   onMouseDown="javascript:setImage('bt_NewVersion1','images/bt_NewVersion_d.gif');"
                   onMouseUp="javascript:setImage('bt_NewVersion1','icon icon-icon-newVersion');"><span
              name="bt_NewVersion1" class="icon icon-icon-newVersion" border="0" alt="<fmt:message key="create_new_version" bundle="${resword}"/>" title="<fmt:message key="create_new_version" bundle="${resword}"/>" align="left" hspace="6"></a>
            </td>
                  <c:if test="${module=='manage'}">
        <td><a href="BatchCRFMigration?module=<c:out value="${module}"/>&crfId=<c:out value="${currRow.bean.id}"/>"
                   onMouseDown="javascript:setImage('bt_Reassign','images/bt_Reassign_d.gif');"
                   onMouseUp="javascript:setImage('bt_Reassign','icon icon-icon-reassign');"><span
                   name="Reassign" class="icon icon-icon-reassign" border="0" alt="<fmt:message key="batch_crf_version_migration" bundle="${resword}"/>" title="<fmt:message key="batch_crf_version_migration" bundle="${resword}"/>" align="left" hspace="6"></a>
               </td>                        
                  </c:if>
          </c:when>
          <c:otherwise>
            <td><a href="RestoreCRF?module=<c:out value="${module}"/>&action=confirm&id=<c:out value="${currRow.bean.id}"/>"
                   onMouseDown="javascript:setImage('bt_Restor3','images/bt_Restore_d.gif');"
                   onMouseUp="javascript:setImage('bt_Restore3','images/bt_Restore.gif');"><span
              name="bt_Restore3" class="icon icon-ccw" border="0" alt="<fmt:message key="restore" bundle="${resword}"/>" title="<fmt:message key="restore" bundle="${resword}"/>" align="left" hspace="6"></a>
            </td>
          </c:otherwise>
        </c:choose>
      </tr>
    </table>
  </td>
</tr>

<c:forEach var ="version" items="${currRow.bean.versions}">
  <%-- color-coded statuses...--%>
  <c:choose>
    <c:when test="${version.status.name eq 'available'}">
      <c:set var="className" value="aka_green_highlight"/>
    </c:when>
    <c:when test="${version.status.name eq 'removed'}">
      <c:set var="className" value="aka_red_highlight"/>
    </c:when>
  </c:choose>
  <tr valign="top">
    <td class="table_cell"><c:out value="${version.name}"/></td>
    <td class="table_cell"><fmt:formatDate value="${version.createdDate}" pattern="${dteFormat}"/></td>
    <td class="table_cell"><c:out value="${version.owner.name}"/></td>
    <td class="table_cell <c:out value='${className}'/>"><c:out value="${version.status.name}"/></td>
    <td class="table_cell">
      <c:choose>
        <c:when test="${version.downloadable}">
          <a href="DownloadVersionSpreadSheet?crfId=<c:out value="${currRow.bean.id}"/>&crfVersionId=<c:out value="${version.id}"/>"
             onMouseDown="javascript:setImage('bt_Download1','images/bt_Download_d.gif');"
             onMouseUp="javascript:setImage('bt_Download1','images/bt_Download.gif');"><span
            name="bt_Download1" class="icon icon-download" border="0" alt="<fmt:message key="download_spreadsheet" bundle="${resword}"/>" title="<fmt:message key="download_spreadsheet" bundle="${resword}"/>" align="left" hspace="6">
          </a>
        </c:when>
        <c:otherwise>
          <fmt:message key="N/A" bundle="${resword}"/>
        </c:otherwise>
      </c:choose>
    </td>
    <td class="table_cell">
      <table border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td>
            <a href="EnketoFormServlet?formLayoutId=<c:out value="${version.id}"/>&studyEventId=<c:out value="0"/>&eventCrfId=<c:out value="0"/>&originatingPage=<c:out value="${originatingPage}"/>&mode=<c:out value="view"/>"       
               onMouseDown="javascript:setImage('bt_View1','images/bt_View_d.gif');"
               onMouseUp="javascript:setImage('bt_View1','images/bt_View.gif');"><span
              name="bt_View1" class="icon icon-search" border="0" alt="<fmt:message key="view" bundle="${resword}"/>" title="<fmt:message key="view" bundle="${resword}"/>" align="left" hspace="6"></a>


          </td>
            <td>
              <a href="ParticipantFormServlet?crfOID=<c:out value="${version.oid}"/>" 
                 onMouseDown="javascript:setImage('bt_ViewParticipant1','images/bt_ViewParticipant_d.gif');"
                 onMouseUp="javascript:setImage('bt_ViewParticipant1','images/bt_ViewParticipant.gif');" target="_blank"><span
                name="bt_ViewParticipant1" class="icon icon-user" border="0" alt="<fmt:message key="view_participant_form" bundle="${resword}"/>" title="<fmt:message key="view_participant_form" bundle="${resword}"/>" align="left" hspace="6"></a>
            </td>
          <c:if test="${version.status.available && userBean.sysAdmin && module=='admin'}">
              <td><a href="LockCRFVersion?module=<c:out value="${module}"/>&id=<c:out value="${version.id}"/>"
                onMouseDown="javascript:setImage('bt_Lock1','images/bt_Lock_d.gif');"
                onMouseUp="javascript:setImage('bt_Lock1','icon icon-archive');"><span
                name="bt_Lock1" class="icon icon-archive" border="0" alt="<fmt:message key="archive" bundle="${resword}"/>" title="<fmt:message key="archive" bundle="${resword}"/>" align="left" hspace="6"></a>
              </td>
      </c:if>
      <c:if test="${version.status.name=='locked'}">             
             <td><a href="UnlockCRFVersion?module=<c:out value="${module}"/>&id=<c:out value="${version.id}"/>"
        onMouseDown="javascript:setImage('bt_Unlock1','images/bt_Unlock_d.gif');"
        onMouseUp="javascript:setImage('bt_Unlock1','images/bt_Unlock.gif');"><span 
        name="bt_Unlock1" class="icon icon-icon-unArchive" border="0" alt="<fmt:message key="unarchive" bundle="${resword}"/>" title="<fmt:message key="unarchive" bundle="${resword}"/>" align="left" hspace="6"></a>
         </td>       
          </c:if>
          <c:if test="${userBean.sysAdmin || (userRole.manageStudy && userBean.name==version.owner.name)}">
            <c:choose>
              <c:when test="${version.status.name == 'removed'}">
                <td><a href="RestoreCRFVersion?module=<c:out value="${module}"/>&action=confirm&id=<c:out value="${version.id}"/>"
                       onMouseDown="javascript:setImage('bt_Restor1','images/bt_Restore_d.gif');"
                       onMouseUp="javascript:setImage('bt_Restore1','images/bt_Restore.gif');"><span
                  name="bt_Restore1" class="icon icon-ccw" border="0" alt="<fmt:message key="restore" bundle="${resword}"/>" title="<fmt:message key="restore" bundle="${resword}"/>" align="left" hspace="6"></a>
                </td>
             </c:when>
            </c:choose>
        </tr>
      </table>
    </td>
  </tr>
</c:forEach>
<tr><td class="table_divider" colspan="9">&nbsp;</td></tr>
  
