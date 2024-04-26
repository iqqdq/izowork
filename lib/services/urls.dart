const baseUrl = 'https://izowork.kz/api/';

const fcmTokenUrl = baseUrl + 'notification/tokenFCM';

const avatarUrl = baseUrl + 'resourses/avatar/';
const contactAvatarUrl = baseUrl + 'resourses/contact-avatar/';
const uploadAvatarUrl = baseUrl + 'user/avatar';
const deleteAccountUrl = baseUrl + 'user/delete-account';
const resetPasswordUrl = baseUrl + 'user/reset-password';

const loginUrl = baseUrl + 'auth/login';
const profileUrl = baseUrl + 'user/me';
const usersUrl = baseUrl + 'user/all';
const userUrl = baseUrl + 'user/one';
const userUpdateUrl = baseUrl + 'user/profile';

const contactUrl = baseUrl + 'contact/one';
const contactsUrl = baseUrl + 'contact/all';
const contactCreateUrl = baseUrl + 'contact/create';
const contactUpdateUrl = baseUrl + 'contact/update';
const contactDeleteUrl = baseUrl + 'contact/delete';
const companyMedialUrl = baseUrl + 'resourses/company-image/';
const uploadContactAvatarUrl = baseUrl + 'contact/avatar';

const productUrl = baseUrl + 'product/one?id=';
const productsUrl = baseUrl + 'product/all';
const productTypesUrl = baseUrl + 'product-type/all';
const productMedialUrl = baseUrl + 'resourses/product-image/';

const companyUrl = baseUrl + 'company/one';
const companiesUrl = baseUrl + 'company/all';
const companyAvatarUrl = baseUrl + 'company/image';
const companyTypesUrl = baseUrl + 'company/types';
const companyCreateUrl = baseUrl + 'company/create';
const companyUpdateUrl = baseUrl + 'company/update';

const taskUrl = baseUrl + 'task/one?id=';
const tasksUrl = baseUrl + 'task/all';
const taskCreateUrl = baseUrl + 'task/create';
const taskUpdateUrl = baseUrl + 'task/update';
const taskFileUrl = baseUrl + 'task/file';
const taskStatesUrl = baseUrl + 'task/states';
const taskMediaUrl = baseUrl + 'resourses/task-file/';

const dealUrl = baseUrl + 'deal/one?id=';
const dealsUrl = baseUrl + 'deal/all';
const dealCountUrl = baseUrl + 'deal/count';
const dealStageUrl = baseUrl + 'deal/stage?deal_id=';
const dealCreateUrl = baseUrl + 'deal/create';
const dealUpdateUrl = baseUrl + 'deal/update';
const dealMediaUrl = baseUrl + 'resourses/deal-file/';
const dealFileUrl = baseUrl + 'deal/file';
const dealProductUrl = baseUrl + 'deal/product';
const dealProcessUrl = baseUrl + 'deal/process';
const dealProcessInfoUrl = baseUrl + 'deal/process/information';
const dealProcessInfoOneUrl = baseUrl + 'deal/process/information-one';
const dealProcessInfoMediaUrl = baseUrl + 'resourses/process-information-file/';
const dealProcessInfoFileUrl = baseUrl + 'deal/process/information/file';

const objectUrl = baseUrl + 'object/one?id=';
const objectsUrl = baseUrl + 'object/all';
const objectTypesUrl = baseUrl + 'object-type/all';
const objectStatesUrl = baseUrl + 'object-stage/all';
const objectCreateUrl = baseUrl + 'object/create';
const objectUpdateUrl = baseUrl + 'object/update';
const objectMediaUrl = baseUrl + 'resourses/object-file/';
const objectFileUrl = baseUrl + 'object/file';

const phasesUrl = baseUrl + 'phase/all';
const phaseUrl = baseUrl + 'phase/one';
const phaseProductsUrl = baseUrl + 'phase/product/all';
const phaseContractorsUrl = baseUrl + 'phase/contractor/all';
const phaseChecklistUrl = baseUrl + 'phase/checklist/all';
const phaseChecklistInfoUrl = baseUrl + 'phase/checklist/information/all';
const phaseChecklistInfoCreateUrl =
    baseUrl + 'phase/checklist/information/create';
const phaseChecklistInfoFileUrl = baseUrl + 'phase/checklist/information/file';
const phaseChecklistInfoMediaUrl =
    baseUrl + 'resourses/checklist-information-file/';
const phaseContractorCreateUrl = baseUrl + 'phase/contractor/create';
const phaseChecklistStateUpdateUrl = baseUrl + 'phase/checklist/update';
const phaseContractorUpdateUrl = baseUrl + 'phase/contractor/update';
const phaseContractorDeleteUrl = baseUrl + 'phase/contractor/delete';
const phaseProductCreateUrl = baseUrl + 'phase/product/create';
const phaseProductUpdateUrl = baseUrl + 'phase/product/update';
const phaseProductDeleteUrl = baseUrl + 'phase/product/delete';

const newsUrl = baseUrl + 'news/all';
const newsOneUrl = baseUrl + 'news/one';
const newsCreateUrl = baseUrl + 'news/create';
const newsCommentUrl = baseUrl + 'news/comment';
const newsFileUrl = baseUrl + 'news/file';
const newsMediaUrl = baseUrl + 'resourses/news-file/';

const chatsUrl = baseUrl + 'chat/chats';
const unreadMessageUrl = baseUrl + 'chat/unread-messages-count';
const chatDmUrl = baseUrl + 'chat/dm';
const messageUrl = baseUrl + 'chat/messages';
const participants = baseUrl + 'chat/participants';
const chatFileUrl = baseUrl + 'chat/file';
const messageReadUrl = baseUrl + 'chat/read';
const messageMediaUrl = baseUrl + 'resourses/message-file/';

const tracesUrl = baseUrl + 'trace/list';
const traceDoActionUrl = baseUrl + 'trace/do-action';

const documentUrl = baseUrl + 'document/list';

const notificationUrl = baseUrl + 'notification/';
const notificationUnreadCountUrl = baseUrl + 'notification/unread-count';
const readNotificationUrl = baseUrl + 'notification/read';

const officeUrl = baseUrl + 'office/all';

const companyAnalyticsUrl = baseUrl + 'analytics/company';
const managerAnalyticsUrl = baseUrl + 'analytics/manager';
const objectAnalyticsUrl = baseUrl + 'analytics/object';
const productAnalyticsUrl = baseUrl + 'analytics/product';
